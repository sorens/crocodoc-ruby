module Crocodoc
  # Provides access to the Crocodoc Download API. The Download API is used for
  # downloading an original of a document, a PDF of a document, a thumbnail of a
  # document, and text extracted from a document.
  class Download
    # The Download API path relative to the base API path
    @@path = '/download/'
    
    # Set the path
    def self.path=(path)
      @@path = path
    end
    
    # Get the path
    def self.path
      @@path
    end
    
    # Download a document's original file from Crocodoc. The file can
    # optionally be downloaded as a PDF, as another filename, with
    # annotations, and with filtered annotations.
    # 
    # @param [String] uuid The uuid of the file to download
    # @param [Boolean] is_pdf Should the file be downloaded as a PDF?
    # @param [Boolean] is_annotated Should the file be downloaded with annotations?
    # @param [String, Array<String>] filter Which annotations should be
    #   included if any - this is usually a string, but could also be an array
    #   if it's a comma-separated list of user IDs as the filter
    # 
    # @return [String] The downloaded file contents as a string
    # @raise CrocodocError
    def self.document(uuid, is_pdf=false, is_annotated=false, filter=nil)
      get_params = {uuid: uuid}
      get_params['pdf'] = 'true' if is_pdf
      get_params['annotated'] = 'true' if is_annotated
      
      if filter
        filter = filter.join(',') if filter.is_a? Array
        get_params['filter'] = filter
      end
      
      Crocodoc._request(self.path, 'document', get_params, nil, false)
    end
    
    # Download a document's extracted text from Crocodoc.
    # 
    # @param [String] uuid The uuid of the file to extract text from
    # 
    # @return [String] The file's extracted text
    # @raise CrocodocError
    def self.text(uuid)
      get_params = {uuid: uuid}
      Crocodoc._request(self.path, 'text', get_params, nil, false)
    end
  
    # Download a document's thumbnail from Crocodoc with an optional size.
    # 
    # @param [String] uuid The uuid of the file to download the thumbnail from
    # @param [Integer] width The width you want the thumbnail to be
    # @param [Integer] height The height you want the thumbnail to be
    # 
    # @return [String] The downloaded thumbnail contents
    # @raise CrocodocError
    def self.thumbnail(uuid, width=nil, height=nil)
      get_params = {uuid: uuid}
    
      if width != nil and height != nil
        get_params['size'] = String(width) + 'x' + String(height)
      end
    
      Crocodoc._request(self.path, 'thumbnail', get_params, nil, false)
    end
  end
end
