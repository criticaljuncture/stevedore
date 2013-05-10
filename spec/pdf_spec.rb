require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Stevedore::Pdf do
  before :each do
    @file_path = File.expand_path(File.dirname(__FILE__) + '/test.pdf')
    @pdf = Stevedore::Pdf.new(@file_path)
  end

  describe '#file_path' do
    it "should return the file path" do
      @pdf.file_path.should == @file_path
    end
  end

  describe '#num_pages' do
    it "should return the number of pages" do
      @pdf.num_pages.should == 2
    end
  end

  describe '#images' do
    it "should return 4 images" do
      @pdf.images.size.should == 4
    end

    it "should return 2 images for page 1 and 2 images for page 2" do
      @pdf.images[0].page_number.should == 1
      @pdf.images[1].page_number.should == 1
      @pdf.images[2].page_number.should == 2
      @pdf.images[3].page_number.should == 2
    end
  end
end
