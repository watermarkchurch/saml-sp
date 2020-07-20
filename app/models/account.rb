class Account < Struct.new(:url_base, :idp_url, :idp_cert)
  def self.get_saml_settings(url_base = nil)
    Account.new(
      url_base || ENV.fetch('BASE_URL'),
      ENV.fetch('IDP_URL'),
      ENV.fetch('IDP_CERT', '')
    ).settings
  end

  def settings
    OneLogin::RubySaml::Settings.new.tap do |settings|
      #SP section
      settings.issuer                         = url_base + "/saml/metadata"
      settings.assertion_consumer_service_url = url_base + "/saml/acs"
      settings.assertion_consumer_logout_service_url = url_base + "/saml/logout"

      # IdP section
      settings.idp_entity_id          = "#{idp_url}/saml/metadata"
      settings.idp_sso_target_url     = "#{idp_url}/saml/auth"
      settings.idp_slo_target_url     = "#{idp_url}/saml/logout"
      settings.idp_cert               = idp_cert

      settings.name_identifier_format = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"

      # Security section
      settings.security[:authn_requests_signed] = false
      settings.security[:logout_requests_signed] = false
      settings.security[:logout_responses_signed] = false
      settings.security[:metadata_signed] = false
      settings.security[:digest_method] = XMLSecurity::Document::SHA1
      settings.security[:signature_method] = XMLSecurity::Document::RSA_SHA1
    end
  end
end
