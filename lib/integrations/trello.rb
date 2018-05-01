require 'api'

class Trello
  def initialize
    @api_key = ENV['TRELLO_API_KEY']
    @token = ENV['TRELLO_OAUTH_TOKEN']
    @lists = {}
    @cards = {}
    @checklists = {}

    load_boards.each do |board_id|
      @lists.merge!(load_lists(board_id))
      @checklists.merge!(load_checklists(board_id))
      @cards.merge!(load_cards(board_id))
    end

  end

  def load_boards
    uri = 'https://api.trello.com/1/members/tptech'
    Api::get(uri + '?key=' + @api_key + '&token=' + @token + '&fields=idBoards')['idBoards']
  end

  def load_lists(board_id)
    uri = "https://api.trello.com/1/boards/#{board_id}/lists"
    lists = {}
    Api::get(uri + '?key=' + @api_key + '&token=' + @token + '&fields=id,name').each do |list|
      lists[list['id']] = list['name']
    end
    lists
  end

  def load_checklists(board_id)
    uri = "https://api.trello.com/1/boards/#{board_id}/checklists"
    checklists = {}
    Api::get(uri + '?key=' + @api_key + '&token=' + @token).each do |checklist|
      card_id = checklist['idCard']
      checklists[card_id] ||= []
      checklists[card_id] << checklist
    end
    checklists
  end

  def load_cards(board_id)
    uri = "https://api.trello.com/1/boards/#{board_id}/cards"
    cards = {}
    Api::get(uri + '?key=' + @api_key + '&token=' + @token).each do |card|
      card['list'] = @lists[card['idList']]
      card['checklists'] = @checklists[card['id']] || []
      cards[card['idShort'].to_i] = card
    end
    cards
  end

  def cards_for(commits)
    cards = {}
    commits.values.each do |message|
      card_number = card_number_of(message)
      cards[card_number] = message
    end

    cards.keys.map do |number|
      @cards[number.to_i]
    end
  end

  def card_number_of(message)
    message.split(':')[0] || ''
  end
end
