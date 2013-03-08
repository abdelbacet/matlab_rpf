function test_suite = test_GetPositionByIndex()
    addpath('../');
    initTestSuite;
end

function test_first_eight_samples
    [x, y] = getPositionByIndex(1:8, 362, 8);
    assertVectorsAlmostEqual(x, repmat(0, 1, 8));
    assertVectorsAlmostEqual(y, repmat(0, 1, 8));
end

function test_second_eight_samples
    [x, y] = getPositionByIndex(9:16, 362, 8);
    assertVectorsAlmostEqual(x, repmat(1, [1, 8]));
    assertVectorsAlmostEqual(y, repmat(0, [1, 8]));
end

function test_third_eight_samples
    [x, y] = getPositionByIndex(17:24, 362, 8);
    assertVectorsAlmostEqual(x, repmat(2, [1, 8]));
    assertVectorsAlmostEqual(y, repmat(0, [1, 8]));
end

function test_pixels_second_row
    idx = 362*8;
    [x, y] = getPositionByIndex(idx + (1:8), 362, 8);
    assertVectorsAlmostEqual(x, repmat(0, [1, 8]));
    assertVectorsAlmostEqual(y, repmat(1, [1, 8]));
end

function test_last_pixel
    idx = 619*362*8 + 361*8;
    [x, y] = getPositionByIndex(idx + (1:8), 362, 8);
    assertVectorsAlmostEqual(x, repmat(361, [1, 8]));
    assertVectorsAlmostEqual(y, repmat(619, [1, 8]));