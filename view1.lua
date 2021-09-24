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

    local scoreEvent = timer.performWithDelay( 250, scoreUp, 0 )


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