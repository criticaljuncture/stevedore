class Stevedore::Pdf
  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  def metadata
    @metadata ||= Metadata.new(self)
  end

  def num_pages
    metadata.num_pages
  end

  class Metadata
    require 'yaml'

    def initialize(pdf)
      @pdf = pdf
      output = Stevedore.run("pdfinfo #{@pdf.file_path}")
      @raw_metadata = output.split("\n").reduce(Hash.new) do |metadata, line|
        name, val = line.split(/: +/,2)
        metadata[name] = val
        metadata
      end
    end

    def num_pages
      @raw_metadata["Pages"].to_i
    end
  end

  def images(base_dir = tmp_dir)
    @images ||= Image.extract_all(self, base_dir)
  end

  def tmp_dir
    @dir ||= Dir.mktmpdir
  end

  class Image
    attr_reader :file_path, :page_number

    def self.extract_all(pdf, base_dir)
      @pdf = pdf
      images = []
      (1..pdf.num_pages).each do |page_number|
        base_name = "#{base_dir}/page-#{sprintf("%00d", page_number)}"
        Stevedore.run("pdfimages -f #{page_number} -l #{page_number} #{@pdf.file_path} #{base_name}")

        Dir.glob("#{base_name}*").sort.each do |file_path|
          images << new(file_path, page_number)
        end
      end

      images
    end

    def initialize(file_path, page_number)
      @file_path = file_path
      @page_number = page_number
    end
  end
end
