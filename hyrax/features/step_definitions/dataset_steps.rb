Given(/^there are exactly (\d+) (\w+) datasets$/) do |number, access|
  # because cucumber tests do not clear fedora/solr between each test, there could be existing datasets from previous
  # tests - so we delete them first
  Dataset.destroy_all
  @datasets = FactoryBot.create_list(:dataset, number, access.to_sym)
  @datasets.each { |obj| ActiveFedora::SolrService.add(obj.to_solr) }
  ActiveFedora::SolrService.commit

  # verify check the expected number of datasets are defined in @datasets
  expect(@datasets.length)
end

When(/^I navigate to the new dataset page$/) do
  visit '/dashboard'
  click_link "Works"
  click_link "Add new work"

  # If you generate more than one work uncomment these lines
  choose "payload_concern", option: "Dataset"
  click_button "Create work"

  # small hack to skip to create dataset page without requiring javascript
  visit new_hyrax_dataset_path
end

When(/^I navigate to the dataset index page$/) do
  visit root_path
  click_link 'Browse all datasets'
  # visit search_catalog_path('f[human_readable_type_sim][]' => 'Dataset')
end

When(/^I create the dataset with:$/) do |table|
  values = table.hashes.first # table is a table.hashes.keys # => [:TITLE, :SUPERVISOR, :DATA_ORIGIN, :CREATOR, :KEYWORD]

  expect(page).to have_content /Add New Dataset/i

  click_link "Files" # switch tab
  expect(page).to have_content /Add files/i
  expect(page).to have_content /Add folder/i
  within('span#addfiles') do
    attach_file("files[]", "#{Hyrax::Engine.root}/spec/fixtures/image.jp2", visible: false)
    attach_file("files[]", "#{Hyrax::Engine.root}/spec/fixtures/jp2_fits.xml", visible: false)
  end

  click_link "Descriptions" # switch tab
  fill_in('Title', with: values[:TITLE])
  fill_in('Supervisor', with: values[:SUPERVISOR])
  select(values[:DATA_ORIGIN], from: 'Data origin')
  fill_in('dataset[complex_person_attributes][0][name][]', with: values[:CREATOR])
  fill_in('Keyword', with: values[:KEYWORD])
  select('Creative Commons BY-SA Attribution-ShareAlike 4.0 International', from: 'dataset[complex_rights_attributes][0][rights][]')

  # With selenium and the chrome driver, focus remains on the
  # select box. Click outside the box so the next line can't find
  # its element
  find('body').click
  choose('dataset_visibility_open')
  expect(page).to have_content('Please note, making something visible to the world (i.e. marking this as Public) may be viewed as publishing which could impact your ability to')
  check('agreement')

  click_on('Save')

  expect(page).to have_content(values[:TITLE])
end

Then(/^I should see links to all the datasets$/) do
  # first, verify @datasets is present and has some data
  expect(@datasets).to be_present
  expect(@datasets.length).to_not be_zero

  # next, verify there is a link to each dataset (using a regular expression to allow for the locale parameter)
  @datasets.each do |dataset|
    expect(page).to have_link(dataset.title.first, href: Regexp.new(hyrax_dataset_path(dataset)))
  end
end
