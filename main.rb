#!ruby -Ks

require 'sdl'
require 'lib/input'
require 'utils.rb'
require 'pumpkin.rb'

class Input
	define_key SDL::Key::ESCAPE, :exit
	define_key SDL::Key::SPACE,  :space
end

SCREEN_WIDTH=800
SCREEN_HEIGHT=600

SDL.init(SDL::INIT_EVERYTHING)
SDL::TTF.init
Font=SDL::TTF.open("HGRSMP.TTF",18)
SDL::WM.set_caption('Halloween Night','halloween01.png')
screen = SDL.set_video_mode(SCREEN_WIDTH, SCREEN_HEIGHT, 16, SDL::SWSURFACE)

pumpkins=Halloween::Pumpkins.new
input=Input.new


#メニュー表示
screen.put(SDL::Surface.load('image/title.png'),0,0)
screen.update_rect(0,0,0,0) 
loop do
	input.poll
	exit if input.exit
	break if input.space
end

# メインループ
loop do
	input.poll
	break if input.exit

	pumpkins.act(input)
	screen.fill_rect(0,0,SCREEN_WIDTH,SCREEN_HEIGHT, [0,0,50])
	pumpkins.render(screen)
	screen.update_rect(0,0,0,0) 
end

# 終了時処理
records=[]
File.open('savedata','w'){|f| f.puts records } unless File.file?('savedata')

#いままでの最高得点と比較する。
score=pumpkins.total_points
File.open('savedata','r'){|f|
	records=f.readlines.collect{|ent| ent.chomp.to_i }.sort{|a,b| b <=> a}
	records=records[0..4]
	higher,lower=records.partition{|ent| ent > score}
	if higher.size==5
		# 残念。
		screen.put(SDL::Surface.load('image/uhm.png'),0,0)
	else
		# 入賞
		records.push pumpkins.total_points
		screen.put(SDL::Surface.load('image/great.png'),0,0)
	end
	records=records.sort{|a,b| b <=> a}
	records=records[0..4]
	Font.draw_solid_utf8(screen,format("%8s",score), 300,165,255,255,255)
	records.each_with_index{|rec,idx|
		if rec==score
			Font.draw_solid_utf8(screen,format("%8s"+"      <<< ",rec), 100,300+idx*30,255,255,255)
		else
			Font.draw_solid_utf8(screen,format("%8s",rec), 100,300+idx*30,255,255,255)
		end
	}
}
File.open('savedata','w'){|f| f.puts records }
screen.update_rect(0,0,0,0) 

loop do
	input.poll
	break if input.space
end
