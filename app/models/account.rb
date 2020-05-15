class Account# < Struct.new(:url_base, :app_id, :idp_info)
  def self.get_saml_settings(url_base)
    # url_base: ENV['BASE_URL'],
    # app_id
  # )
    # this is just for testing purposes.
    # should retrieve SAML-settings based on subdomain, IP-address, NameID or similar
    settings = OneLogin::RubySaml::Settings.new

    url_base ||= "http://saml-test.wcc"

    # Example settings data, replace this values!

    # When disabled, saml validation errors will raise an exception.
    settings.soft = true

    #SP section
    settings.issuer                         = url_base + "/saml/metadata"
    settings.assertion_consumer_service_url = url_base + "/saml/acs"
    settings.assertion_consumer_logout_service_url = url_base + "/saml/logout"

    onelogin_app_id = 'saml-test'
    idp_base = 'http://login.wcc'

    # IdP section
    settings.idp_entity_id                  = "#{idp_base}/saml/metadata/#{onelogin_app_id}"
    settings.idp_sso_target_url             = "#{idp_base}/trust/saml2/http-redirect/sso/#{onelogin_app_id}"
    settings.idp_slo_target_url             = "#{idp_base}/trust/saml2/http-redirect/slo/#{onelogin_app_id}"
    settings.idp_cert                       = ""


    # or settings.idp_cert_fingerprint           = ""
    #    settings.idp_cert_fingerprint_algorithm = XMLSecurity::Document::SHA1

    settings.name_identifier_format         = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"

    # Security section
    settings.security[:authn_requests_signed] = false
    settings.security[:logout_requests_signed] = false
    settings.security[:logout_responses_signed] = false
    settings.security[:metadata_signed] = false
    settings.security[:digest_method] = XMLSecurity::Document::SHA1
    settings.security[:signature_method] = XMLSecurity::Document::RSA_SHA1

    settings
  end
end
