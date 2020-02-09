# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

files_dir = 'db/seed_files/scraped_data'

files = Dir.glob("#{files_dir}/*").map do |path|
  File.basename(path)
end

files = [files.first]

files.each do |file|
  IO.foreach(File.join(files_dir, file)) do |line|
    json = JSON.parse(line)
    site_url = json["site_url"]

    site = Site.find_or_create_by(url: site_url)

    page_url = json["page_url"]
    html = json["html"]
    content = Utilities.html_to_string(html)

    site.pages.create(
      page_url: page_url,
      html: html,
      content: content
    )

  end
end
