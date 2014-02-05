class Visitor < ActiveRecord::Base
  has_no_table
  column :favorite, :string
  column :comment, :string
  validates_presence_of :favorite

  NAMES = ENV["GSP13_NAMES"].split(",")

  def update_spreadsheet
    connection = GoogleDrive.login(ENV["GMAIL_USERNAME"], ENV["GMAIL_PASSWORD"])
    ss = connection.spreadsheet_by_title('GSP13-Eighty-Days-Responses')
    if ss.nil?
      ss = connection.create_spreadsheet('GSP13-Eighty-Days-Responses')
    end
    ws = ss.worksheets[0]
    name_row = 1 + ws.num_rows
    ws[name_row, 1] = Time.now
    ws[name_row, 2] = self.favorite
    ws[name_row, 3] = self.comment
    ws.save
  end

end
