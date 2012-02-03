module ANT
	def show_gif_image(path)
		require 'tk'
		TkButton.new do
			image TkPhotoImage.new(file: path)
			command lambda {TkRoot.destroy }
			pack
		end
		Tk.mainloop
	end
end
