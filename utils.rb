#!ruby -Ks

module Halloween
	module Utils

		# 画像をファイルから読み込み、Surfaceとして返却
		def self.load_image(fname)
			image = SDL::Surface.load(fname)
			image.set_color_key(SDL::SRCCOLORKEY, [255,255,255])

			image
		end
	end
end
