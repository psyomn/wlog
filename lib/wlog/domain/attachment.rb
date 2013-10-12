module Wlog
# <<Active Record>>
# OO way of handling blobs of data, to be stored in memory or in db.
class Attatchment

  # [String] Container for the actual binary data of whatever you're
  # attaching.
  attr_accessor :data
  # [String] The original filename of the file
  attr_accessor :filename
  # [String] optional given name for the attachment
  attr_accessor :given_name
end
end # module Wlog

