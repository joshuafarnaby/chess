# frozen_string_literal: true

module Convertable
  FILE_INDEX_CONVERTER = {
    'A' => 0,
    'B' => 1,
    'C' => 2,
    'D' => 3,
    'E' => 4,
    'F' => 5,
    'G' => 6,
    'H' => 7
  }.freeze

  def convert_filerank_to_index(filerank)
    temp = filerank.split('')
    [7 - (temp[1].to_i - 1), FILE_INDEX_CONVERTER[temp[0]]]
  end

  def gets_row_index(filerank)
    7 - (filerank.split('')[1].to_i - 1)
  end

  def gets_column_index(filerank)
    FILE_INDEX_CONVERTER[filerank.split('')[0]]
  end
end
