#!ruby -Ks

module Halloween
	class Pumpkins
		def initialize
			@pumpkins=[]

			@num_of_pump =0
			@max_pumpkin =50

			@total_points=0
			@num_of_catched=0
		end
		attr_reader :total_points

		def act(input)
			# マウスボタンが押されたかの判定
			mx,my,lbutton,rbutton = SDL::Mouse.state
			mx,my=nil,nil unless lbutton
			while @pumpkins.size < 10 && @num_of_pump < @max_pumpkin
				@num_of_pump+=1
				@pumpkins.push Halloween::PumpkinHead.new 
			end
			@pumpkins.each{|pump| 
				point=pump.act(input,mx,my)
				if point.is_a?(Integer)
					@total_points+=point
					@num_of_catched+=1
				end
			}
			@pumpkins.delete_if{|pump| pump.dead? }
		end

		def render(screen)
			@pumpkins.each{|pump| pump.render(screen)}
			Font.draw_solid_utf8(screen,format("%8s"+"("+"%2s"+")",@total_points,@num_of_catched), 600,10,255,255,255)
		end

	end

	class PumpkinHead

		PUMPKIN_W=256
		PUMPKIN_H=256

		def initialize
			@x=rand(SCREEN_WIDTH-PUMPKIN_W)
			@y=rand(SCREEN_HEIGHT-PUMPKIN_H)
			@base =Utils.load_image('image/base.png')
			@eye  =Utils.load_image("image/eye#{rand(2)+1}.png")
			@mouth=Utils.load_image("image/mouth#{rand(2)+1}.png")
			@accessory=case rand(5)
								when 0;nil
								when 1;Utils.load_image('image/accessory_flower.png')
								when 2;Utils.load_image('image/accessory_ribbon.png')
								when 3;Utils.load_image('image/accessory_viking.png')
								when 4;Utils.load_image('image/accessory_witch.png')
								end
			@cloud=[Utils.load_image('image/cloud1.png'),Utils.load_image('image/cloud2.png')]
			@state=:alive
			@point=1000
			@vanishing_count=0
			re_route
		end
		attr_reader :x, :y

		def dead?; @state==:dead ; end
		def catched?; @state!=:alive ; end

		def act(input,mx=nil,my=nil)
			@point-=10 if @point > 0
			case @state
			when :vanishing
				@speed=0
				@vanishing_count+=1
				@state=:dead if @vanishing_count > 60
			when :dead
			when :alive
				# マウスボタンの当たり判定
				if mx && my
					focus=100
					if ( left_edge < mx-focus ) && ( mx < right_edge-focus ) && ( upper_edge < my-focus ) && ( my < bottom_edge-focus )
						@state=:vanishing
						#ポイント加算
						return @point
					end
				end
				@x=@x+(@dest_x*@speed)
				@y=@y+(@dest_y*@speed)
				if ( left_edge < 0 ) || ( right_edge > SCREEN_WIDTH) || ( upper_edge < 0 ) || ( bottom_edge > SCREEN_HEIGHT )
					@x = 0 if left_edge < 0 
					@y = 0 if upper_edge < 0 
					@x = SCREEN_WIDTH-PUMPKIN_W  if right_edge > SCREEN_WIDTH
					@y = SCREEN_HEIGHT-PUMPKIN_H if bottom_edge > SCREEN_HEIGHT
					re_route
				end
			end
		end

		def render(screen)
			case @state
			when :alive
				screen.put(@base,@x,@y)
				screen.put(@eye,@x,@y)
				screen.put(@mouth,@x,@y)
				screen.put(@accessory,@x,@y) if @accessory
			when :vanishing
				screen.put(@cloud[(@vanishing_count/10)%2],@x,@y)
			when :dead
				#
			end
		end

		:private
		def left_edge; @x; end
		def right_edge; @x+PUMPKIN_W; end
		def upper_edge; @y; end
		def bottom_edge; @y+PUMPKIN_H; end

		def re_route
			@dest_x=rand(5)-2 # 進む方向性
			@dest_y=rand(5)-2 # 進む方向性
			@speed =rand(5)+1
			@dest_x=rand(5)-2 while @dest_x == 0
			@dest_y=rand(5)-2 while @dest_y == 0
			@speed =rand(5)+1 while @speed  == 0
		end

	end
end



