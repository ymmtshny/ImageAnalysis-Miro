class Picture < ApplicationRecord
  has_attached_file :image, :styles => {
      :medium => "300x300>", :thumb => "100x100>", :gray => "300x300>" ,
  },
  :convert_options => { :gray => '-colorspace Gray' },
  :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  def dark_percent(n)
    dark_percent = 0
    colors = Miro::DominantColors.new(self.image.path(:gray))
    colors.to_rgb.each_with_index do |rgb,index|
      dark_percent += colors.by_percentage[index] * 100 if colors.to_rgb[index][0] <= n
    end
    dark_percent
  end
end
