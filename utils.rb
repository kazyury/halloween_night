#!ruby -Ks

module Halloween
	module Utils

		# �摜���t�@�C������ǂݍ��݁ASurface�Ƃ��ĕԋp
		def self.load_image(fname)
			image = SDL::Surface.load(fname)
			image.set_color_key(SDL::SRCCOLORKEY, [255,255,255])

			image
		end
	end
end
