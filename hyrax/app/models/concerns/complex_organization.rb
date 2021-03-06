class ComplexOrganization < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::ORG.Organization
  property :organization, predicate: ::RDF::Vocab::ORG.organization
  property :sub_organization, predicate: ::RDF::Vocab::ORG.hasSubOrganization
  property :purpose, predicate: ::RDF::Vocab::ORG.purpose
  property :complex_identifier, predicate: ::RDF::Vocab::MODS.identifierGroup,
            class_name:"ComplexIdentifier"
  accepts_nested_attributes_for :complex_identifier

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#organization#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
