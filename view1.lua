-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )

	sceneGroup:insert( background )

	-- 점수 올리기 
		-- 0.25초 마다 1점 씩 상승

    local score = 0
    local showScore = display.newText(score, display.contentWidth*0.3, display.contentHeight*0.2)
    showScore:setFillColor(0)
    showScore.size = 50

    local function scoreUp ( event )
    	score = score + 1
    	showScore.text = score
    end

    local scoreEvent


	-- 공룡 움직이기(애니메이션) : 녹색 네모(임시버튼) 클릭하면 점프, 키보드 a 누르면 hurt 애니메이션과 함께 종료 
	
	-- local dino_sheet = graphics.newImageSheet( "Content/Player.png", { width = 16, height = 16, numFrames = 6 })

		-- 임시 리소스에는 사이사이에 여유로 픽셀이 있어서 일단 하나하나 프레임을 지정해줌.. 
		-- 디자이너분이 여유 픽셀없이 꽉꽉 채워주시면 위에처럼 한 줄짜리 코드로 바꿔서 사용 예정

	local dino_sheet = graphics.newImageSheet( "Content/Player.png", {
			frames = {
				{ x = 0*17, y = 0, width = 16, height = 16 },
				{ x = 1*17, y = 0, width = 16, height = 16 },
				{ x = 2*17, y = 0, width = 16, height = 16 },
				{ x = 3*17, y = 0, width = 16, height = 16 },
				{ x = 4*17, y = 0, width = 16, height = 16 },
				{ x = 5*17, y = 0, width = 16, height = 16 }
			}
		})

	local sepuencesData =
	{
		{ name = "stand", start = 1, count = 1},
		{ name = "run", start = 1, count = 4, time = 400 },
		{ name = "jump", start = 5, count = 1, loopCount = 1, time = 600},
		{ name = "hurt", start = 6, count = 1}
	}

	-- 공룡 오브젝트 생성
	local dino = display.newSprite( dino_sheet, sepuencesData )
	dino.x, dino.y = display.contentCenterX, display.contentCenterY

    dino:play()

    -- 임시 버튼
    local jumpButton = display.newRect( display.contentWidth*0.7, display.contentHeight*0.8, 200, 100)
    jumpButton:setFillColor(0, 1, 0)

    local function jump( ... )

    	-- 점프 애니메이션
    	dino:setSequence( "jump" )
	    dino:play()
	    --

    end
    jumpButton:addEventListener("tap", jump)


    local function dino_spriteListenr( event )
    	if event.phase == "began" then -- sepuence가 시작할 때(바뀌었을 때)

    		if dino.sequence == "jump" then -- jump 애니메이션이 재생될 때
    			-- 점프할 때 transition을 여기 넣어도 될 듯 합니다..


	    	elseif dino.sequence == "hurt" then -- hurt 애니메이션이 재생될 때

	    		dino:setFillColor(0.75, 0.5, 0.5)

	    		timer.cancel( scoreEvent )
	    		display.remove( jumpButton ) -- 임시 버튼 삭제
	    	end

    	elseif event.phase == "ended" then -- sepuence가 끝났을 때

    		-- jump 애니메이션 후, run으로 자동으로 넘어가도록 설정
    		dino:setSequence( "run" )
    		dino:play()
    		dino.width, dino.height = 100, 100
    	end

    	-- 임시리소스가 도트 크기라 이미지 크기를 계속 다시 설정해주어야 함..
    	dino.width, dino.height = 100, 100 -- 디자이너분이 이미지 크기 적절히 주시면 빠질 코드
    end
    dino:addEventListener( "sprite", dino_spriteListenr )





    -- 애니메이션 디버그용 임시 이벤트

    local function onKeyEvent( event )

	    if event.keyName == "a" then

	    	-- hurt 애니메이션 재생
	    	dino:setSequence( "hurt" )
	    	dino:play()
	    	--

	    end
    end
    Runtime:addEventListener( "key", onKeyEvent )


    -- 음악
	local music = audio.loadStream( "Content/music1.ogg" )
	local bgMusic
	local soundOn = 0
	local bgmUI = {}
	bgmUI[0] = display.newImageRect("Content/on.png", 55, 55)
	bgmUI[0].x, bgmUI[0].y = 1240, 40
	bgmUI[0].alpha = 0
	bgmUI[1] = display.newImageRect("Content/off.png", 55, 55)
	bgmUI[1].x, bgmUI[1].y = 1240, 40

	local function soundONOFF( ... )
		if soundOn == 1 then -- 소리 켜져 있으면 끄고
			soundOn = 0
			bgmUI[0].alpha = 0
			bgmUI[1].alpha = 1
			audio.stop(bgMusic)
		else -- 꺼져있으면 키고,,
			soundOn = 1
			bgmUI[0].alpha = 1
			bgmUI[1].alpha = 0
			bgMusic = audio.play(music, { channel=1, loops=-1, fadein=5000 })
		end
	end
	bgmUI[0]:addEventListener("tap", soundONOFF)
	bgmUI[1]:addEventListener("tap", soundONOFF)

	-- 일시정지
	local playUI = {}
	playUI[0] = display.newImageRect("Content/play.png", 55, 55)
	playUI[0].x, playUI[0].y = 1180, 40
	playUI[1] = display.newImageRect("Content/stop.png", 55, 55)
	playUI[1].x, playUI[1].y = 1180, 40
	playUI[1].alpha = 0

	local UI = {} --일시정지 누르면 뜨는 것들
	UI[0] = display.newRect(640, 360, 600, 300)
	UI[0]:setFillColor(0.5)
	UI[1] = display.newImage("Content/start.png") 
	UI[1].x, UI[1].y = 640, 400
	UI[2] = display.newImageRect("Content/x.png", 30, 30)
	UI[2].x, UI[2].y = 920, 230

	for i = 0, #UI do
		UI[i].alpha = 0
	end

	local function tapPlay( ... )
		-- 시작하는 거 구현 
		playUI[0].alpha = 0
		playUI[1].alpha = 1

		--bgm도 같이 켜지기
		soundOn = 0
		soundONOFF()

		for i = 0, #UI do
			UI[i].alpha = 0
		end

		-- 게임 재개
		scoreEvent = timer.performWithDelay( 250, scoreUp, 0 )
		dino:setSequence( "run" )
	    dino:play()
	end

	local function tapStop( ... )
		-- 멈추는 거 구현
		playUI[0].alpha = 1
		playUI[1].alpha = 0

		--bgm도 같이 멈추기,,
		soundOn = 1
		soundONOFF()

		for i = 0, #UI do
			UI[i].alpha = 1
		end

		-- 게임 중단
		timer.cancel( scoreEvent )
		dino:setSequence( "stand" )
	    dino:play()
	end

	local function tapX( ... )
		for i = 0, #UI do
			UI[i].alpha = 0
		end
	end

	playUI[0]:addEventListener("tap", tapPlay)
	playUI[1]:addEventListener("tap", tapStop)
	UI[1]:addEventListener("tap", tapPlay)
	UI[2]:addEventListener("tap", tapX)

	-- 죽었을 때 화면 전환 (어디다 추가해야할지 모르겠어서 일단 여기다가 넣음)
	local function onKeyEvent2( event )
	    if event.keyName == "s" then
	    	composer.setVariable("score", score)
	    	composer.gotoScene("end")
	    end
    end
    Runtime:addEventListener( "key", onKeyEvent2 )


    sceneGroup:insert( showScore )
    sceneGroup:insert( dino )
    for i = 0, #bgmUI do sceneGroup:insert( bgmUI[i] ) end
    for i = 0, #playUI do sceneGroup:insert( playUI[i] ) end
    for i = 0, #UI do sceneGroup:insert( UI[i] ) end
  
	--jump&slide
	local w,h = display.contentWidth, display.contentHeight/2
	-- 배경
	local background = display.newImageRect("Content/sky.png", display.contentWidth, display.contentHeight)
    background.x, background.y = display.contentWidth/2, display.contentHeight/2
    --임시로 1장짜리 선인장 이미지 사용
	local player = display.newImageRect("Content/Cactus A.png", 61, 101)
    player.x, player.y = display.contentWidth/2, display.contentHeight/2


    local function playerDown( event )--플레이어 점프 후 원상복귀
    	transition.to( player, { time=600,  y=(player.y+50)} )
    end

	local function onKeyJumpEvent( event )--점프키 구현 함수-캐릭터 jump 애니메이션 연결
	 	if ( event.keyName == "space" ) and ( event.phase == "down" ) and (player.y == h)then
	 			transition.to( player, { time=600,  y=(player.y-50), onComplete = playerDown } )--플레이어 up
	 			print("jump")
	    end
	end--점프는 슬라이드처럼 시간 조절불가 


	local function onKeySlideEvent( event )--슬라이드키 구현 함수
	 	if ( event.keyName == "down" ) and ( event.phase == "down" ) and (player.y == h)then
	 			transition.to( player, { time=50, rotation = -90,  y=(player.y+20) } )
	 			print("slide")--                      ㄴ일단 알아보도록 이미지 회전->나중에 애니메이션 연결
	    end
	    if ( event.keyName == "down" ) and ( event.phase ~= "submitted" ) and (player.y == h+20)then
 			transition.to( player, { time=300,  y=(player.y-20), rotation = 0} )
 		end
	end--슬라이드는 누르고 있는 시간만큼 유지됨


	Runtime:addEventListener( "key", onKeyJumpEvent )
	Runtime:addEventListener( "key", onKeySlideEvent )
=======
	
	--
	physics.start()
    	physics.setGravity( 0, 0 )

	local sky = display.newImageRect("img/Sky.png", display.contentWidth, display.contentHeight)
	sky.x, sky.y = display.contentWidth/2, display.contentHeight/2

	local ground = display.newImageRect("img/Ground.png", 1280, 200)
	ground.x, ground.y = display.contentWidth/2, display.contentHeight-50

	---------장애물 생성------------

	--일단 장애물 크기는 제가 임의로 해놓았습니다.
	--리소스 완성되면 크기하고 좌표 수정하겠습니다.
	--장애물 애니메이션의 경우 현 리소스(선인장 A,B,C같이 imagesheet 없고 단일이미지)로 어떻게 적용해야할지 잘 모르겠습니다....
		-->혹시 최종 리소스에 애니메이션이 있는 장애물들이 나온다면 적용하겠습니다.

	local obstacle = {}
	--------땅 장애물
	obstacle[1] = display.newImageRect("img/Cactus A.png", 50, 100)
	obstacle[2] = display.newImageRect("img/Cactus B.png", 200, 100)
	obstacle[3] = display.newImageRect("img/Cactus C.png", 200, 100)
	obstacle[4] = display.newImageRect("img/Back A.png", 200, 100)
	obstacle[5] = display.newImageRect("img/Back B.png", 100, 100)
	---------하늘에서 날아오는 장애물, 마땅한게 없어 구름으로 대체합니다.
	obstacle[6] = display.newImageRect("img/Cloud A.png", 200, 100)
	obstacle[7] = display.newImageRect("img/Cloud B.png", 100, 50)
	--[[or i = 1, 3, 1 do
		obstacle[i].x, obstacle[i].y = display.contentWidth+200, display.contentHeight-250
	end]]
	for i = 1, 5, 1 do 
		--화면 밖에 배치, 땅장애물 초기 위치
		obstacle[i].x, obstacle[i].y = display.contentWidth+200, display.contentHeight-200
	end
	for i = 6, 7, 1 do 
		--화면 밖에 배치, 하늘장애물 초기 위치
		obstacle[i].x, obstacle[i].y = display.contentWidth+200, 250
	end

	local cooltime
	local obs_idx

	--------------------------------------------

	function start()
		cooltime = math.random(1, 4)--0.5~2초 사이의 간격으로 스폰
		obs_idx = math.random(1, 7)--1~5번 장애물 중 랜덤선택
		print("spawn time = "..cooltime)
		print("obstacle idx is "..obs_idx)
		timer.performWithDelay(cooltime*500, spawn_obstacle)
	end

	function obs_reset()--다시 화면 밖으로(초기상태로)
		print("obstacle.x is out of screen")

		obstacle[obs_idx]:setLinearVelocity( 0, 0 )
		physics.removeBody(obstacle[obs_idx])
		obstacle[obs_idx].x = display.contentWidth+200

		start()
	end

	function spawn_obstacle ()
		print("spawn obstacle")

		physics.addBody( obstacle[obs_idx], "dynamic" )
		obstacle[obs_idx]:setLinearVelocity( -500, 0 )--장애물 이동

		timer.performWithDelay(4000, obs_reset)
	end
	
	start()

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
	elseif phase == "did" then

	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
	elseif phase == "did" then

	end
end

function scene:destroy( event )
	local sceneGroup = self.view

end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
