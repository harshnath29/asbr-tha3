function runFullPipeline(prefix)
    calBody = loadCalBody(prefix + "-calbody.txt");
    calReadings = loadCalReadings(prefix + "-calreadings.txt");
    G_frames = loadEmpivot(prefix + "-empivot.txt");
    [D_frames, H_frames] = loadOptpivot(prefix + "-optpivot.txt");

    C_expected = computeExpectedC(calBody, calReadings);
    [~, p_dimple_em] = emPivotCalibration(G_frames);
    [~, p_dimple_opt] = opticalPivotCalibration(D_frames, H_frames, calBody.d);

    writeOutput1(C_expected, p_dimple_em, p_dimple_opt, prefix + "-output1.txt");
end
