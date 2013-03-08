function test_suite = test_GetIndexByPosition()
    addpath('../');
    initTestSuite;
end

function test_top_left
    idx = getIndexByPosition([0,0], 8, 362);
    assertElementsAlmostEqual(1, idx);
end

function test_bot_left
    idx = getIndexByPosition([0,619], 8, 362);
    assertElementsAlmostEqual(8*362*619 + 1, idx);
end

function test_top_right
    idx = getIndexByPosition([361,0], 8, 362);
    assertElementsAlmostEqual(8*361 + 1, idx);
end

function test_bot_right
    idx = getIndexByPosition([361,619], 8, 362);
    assertElementsAlmostEqual(1795513, idx);
end
