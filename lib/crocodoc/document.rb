module Crocodoc
  # Provides access to the Crocodoc Document API. The Document API is used for
  # uploading, checking status, and deleting documents.
  class Document
    # The Document API path relative to the base API path
    @@path = '/document/'
    
    # Set the path
    def self.path=(path)
      @@path = path
    end
    
    # Get the path
    def self.path
      @@path
    end
    
    # Delete a file on Crocodoc by UUID.
    # 
    # @param [String] uuid The uuid of the file to delete
    # 
    # @return [Boolean] Was the file deleted?
    # @raise [CrocodocError]
    def self.delete(uuid)
      post_params = {'uuid' => uuid}
      Crocodoc._request(self.path, 'delete', nil, post_params)
    end
    
    # Check the status of a file on Crocodoc by UUID. This method is
    # polymorphic and can take an array of UUIDs and return an array of status
    # hashes about those UUIDs, or can also take a one UUID string and return
    # one status hash for that UUID.
    # 
    # @param [Array<String>, String] uuids An array of the uuids of the file to
    #   check the status of - this can also be a single uuid string
    # 
    # @return [Array<Hash<String,>>, Hash<String,>] An array of hashes (or just
    #   an hash if you passed in a string) of the uuid, status, and viewable
    #   bool, or an array of the uuid and an error
    # @raise [CrocodocError]
    def self.status(uuids)
      is_single_uuid = uuids.is_a? String
      uuids = [uuids] if is_single_uuid
      get_params = {'uuids' => uuids.join(',')}
      response = Crocodoc._request(self.path, 'status', get_params, nil)
      is_single_uuid ? response[0] : response
    end
  	
  	# Upload a file to Crocodoc with a URL.
    # 
    # @param url_or_file [String, File] The url of the file to upload or a file resource
    # 
    # @return [String] The uuid of the newly-uploaded file
    # @raise [CrocodocError]
    def self.upload(url_or_file)
      post_params = {}
      
      if url_or_file.is_a? String
        post_params['url'] = url_or_file
      elsif url_or_file.is_a? File
      	post_params['file'] = url_or_file
      else
      	return Crocodoc::_error('invalid_url_or_file_param', self.name, __method__, nil)
      end
      
      response = Crocodoc::_request(self.path, 'upload', nil, post_params)
      
      unless response.has_key? 'uuid'
      	return Crocodoc::_error('missing_uuid', self.name, __method__, response)
      end
      
      response['uuid']
    end
  end
end
