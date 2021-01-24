--[[
  ** Build config for spath3 using l3build **
--]]

-- Identification
module  = "spath3"
pkgvers = "2.0"
pkgdate = "2021/01/19"
ctanpkg = module
ctanzip = ctanpkg.."-"..pkgvers
packtdszip = true

-- Configuration of files for build and installation
maindir        = "."
docfiledir     = "."
textfiles      = {"README.md"}
sourcefiledir  = "."
sourcefiles    = {"calligraphy_doc.tex", "knots_doc.tex", "spath3_code.dtx", "spath3.sty", "spath3.tex"}
installfiles   = {"*.tex", "*.sty", "*.dtx", "*.ins"}

tdslocations  = {
  "tex/latex/spath3/spath3.sty",
  "tex/latex/spath3/tikzlibrarycalligraphy.code.tex",
  "tex/latex/spath3/tikzlibraryknots.code.tex",
  "tex/latex/spath3/tikzlibraryspath3.code.tex",
  "doc/latex/spath3/calligraphy.pdf",
  "doc/latex/spath3/calligraphy_doc.tex",
  "doc/latex/spath3/knots_doc.tex",
  "doc/latex/spath3/knots_doc.pdf",
  "doc/latex/spath3/spath3.tex",
  "doc/latex/spath3/spath3.pdf",
  "doc/latex/spath3/spath3_code.pdf",
  "source/latex/spath3/spath3_code.ins",
  "source/latex/spath3/spath3_code.dtx"
}

-- Unpacking files from .dtx file
unpackfiles = { "spath3_code.dtx" }
unpackopts  = "--interaction=batchmode"
unpackexe   = "luatex"

-- Generating documentation
typesetfiles  = {"spath3_code.dtx", "calligraphy_doc.tex", "knots_doc.tex", "spath3.tex"}
typesetexe    = "lualatex"
typesetopts   = "-interaction=batchmode"

-- Clean files
cleanfiles = {module..".pdf", ctanzip..".curlopt", ctanzip..".zip"}

-- Create make_tmp_dir() function
local function make_tmp_dir()
  -- Fix basename(path) in windows
  local function basename(path)
    return path:match("^.*[\\/]([^/\\]*)$")
  end
  local tmpname = os.tmpname()
  tmpdir = basename(tmpname)
  -- Create a tmp dir
  print("Creating the temporary directory ./"..tmpdir)
  errorlevel = mkdir(tmpdir)
  if errorlevel ~= 0 then
    error("** Error!!: The ./"..tmpdir.." directory could not be created")
    return errorlevel
  end
  -- Copy files
  print("Copying spath3_code.dtx from "..sourcefiledir.." to ./"..tmpdir)
  errorlevel = cp("*.dtx", sourcefiledir, tmpdir)
  if errorlevel ~= 0 then
    error("** Error!!: Can't spath3_code.dtx from "..sourcefiledir.." to ./"..tmpdir)
    return errorlevel
  end
  -- Unpack files
  print("Unpacks the source files into ./"..tmpdir)
  local file = jobname(tmpdir.."/spath3_code.dtx")
  errorlevel = run(tmpdir, "pdftex -interaction=batchmode "..file..".dtx > "..os_null)
  if errorlevel ~= 0 then
    error("** Error!!: pdftex -interaction=batchmode "..file..".dtx")
    return errorlevel
  end
  return 0
end

-- We added a new target "testpkg" to run the tests files in test-pkg/
if options["target"] == "testpkg" then
  -- Create a tmp dir and unpack files
  make_tmp_dir()
  -- Copy testsuite.tex file
  print("** Copying testsuite.tex to ./"..tmpdir)
  errorlevel = cp("testsuite.tex", sourcefiledir, tmpdir)
  if errorlevel ~= 0 then
    error("** Error!!: Can't copy testsuite.tex to ./"..tmpdir)
    return errorlevel
  end
  -- First
  local file = jobname(tmpdir.."/testsuite.tex")
  print("** Running first test on the file: "..file..".tex using [latex]")
  errorlevel = run(tmpdir, "latex "..file..".tex")
  if errorlevel ~= 0 then
    error("** Error!!: latex "..file..".tex")
    return errorlevel
  end
  print("** Running first test on the file: "..file..".tex using [latex-dev]")
  errorlevel = run(tmpdir, "latex-dev "..file..".tex")
  if errorlevel ~= 0 then
    error("** Error!!: latex-dev "..file..".tex")
    return errorlevel
  end
  -- Second
  print("** Running second test on the file: "..file..".tex using [pdflatex]")
  errorlevel = run(tmpdir, "pdflatex "..file..".tex")
  if errorlevel ~= 0 then
    error("** Error!!: pdflatex "..file..".tex")
    return errorlevel
  end
  print("** Running second test on the file: "..file..".tex using [pdflatex-dev]")
  errorlevel = run(tmpdir, "pdflatex-dev "..file..".tex")
  if errorlevel ~= 0 then
    error("** Error!!: pdflatex-dev "..file..".tex")
    return errorlevel
  end
  -- Third
  print("** Running third test on the file: "..file..".tex using [lualatex]")
  errorlevel = run(tmpdir, "lualatex "..file..".tex")
  if errorlevel ~= 0 then
    error("** Error!!: lualatex "..file..".tex")
    return errorlevel
  end
  print("** Running third test on the file: "..file..".tex using [lualatex-dev]")
  errorlevel = run(tmpdir, "lualatex-dev "..file..".tex")
  if errorlevel ~= 0 then
    error("** Error!!: lualatex-dev "..file..".tex")
    return errorlevel
  end
  -- Fourth
  print("** Running fourth test on the file: "..file..".tex using [xelatex]")
  errorlevel = run(tmpdir, "xelatex "..file..".tex")
  if errorlevel ~= 0 then
    error("** Error!!: xelatex "..file..".tex")
    return errorlevel
  end
  print("** Running fourth test on the file: "..file..".tex using [xelatex-dev]")
  errorlevel = run(tmpdir, "xelatex-dev "..file..".tex")
  if errorlevel ~= 0 then
    error("** Error!!: xelatex-dev "..file..".tex")
    return errorlevel
  end
   -- If are OK then remove ./temp dir
  cleandir(tmpdir)
  lfs.rmdir(tmpdir)
  print("Remove temporary directory ./"..tmpdir)
  os.exit(0)
end

-- We added a new target "examples" to run the examples files for scontents
if options["target"] == "examples" then
  -- Create a tmp dir and unpack files
  make_tmp_dir()
  -- Create a sub dir for sample files
  errorlevel = mkdir(tmpdir.."/knotdiagrams")
  if errorlevel ~= 0 then
    error("** Error!!: The ./"..tmpdir.."/knotdiagrams directory could not be created")
    return errorlevel
  end
  -- List of sample files
  samples = {
    --"spath_interface.tex",--! Package pgfkeys Error: I do not know the key '/tikz/save spath',
    --"knots_test.tex", -- hobby :) ! LaTeX3 Error: Inconsistent local/global assignment
    --"trefoil_moves_new.tex",-- ! Package tikz Error: Sorry, the system call 'pdflatex -shell-escape -halt-on-e
    --"findintersection.tex",-- Package pgfkeys Error: I do not know the key '/tikz/split at self intersections', to which you passed '{coil}{1111111111111111111111}'
    --"knotsarrows.tex",--  ! Missing number, treated as zero. \__dim_eval_end:
    --"renderpath.tex",-- ! Package pgfkeys Error: I do not know the key '/tikz/save spath',
    --"knot_shading.tex",--! Undefined control sequence.<argument> \g__prg_map_int
    --"smallcrossings.tex",--! Package tikz Error: Sorry, the system call 'pdflatex -shell-escape -halt-on-e
    --"knightstour.tex",-- ! Package pgfkeys Error: I do not know the key '/tikz/save spath'
    --"spath3_test.tex",-- hobby :) ! LaTeX3 Error: Inconsistent local/global assignment
    --"welding.tex",-- ! Package pgfkeys Error: I do not know the key '/tikz/save spath',
    "calligraphy_test.tex",
    "knots_celtic.tex",
    "localglobal.tex",
    "knots_more_celtic.tex",
    "nfoil.tex",
    "twistedpair.tex",
    "calligraphy_closed.tex",
    "knot-examples.tex",
    "knots_small.tex",
    "pentagram.tex",
    "olympic.tex",
    "calligraphy_decorations.tex",
    "knot_pins.tex",
    "calligraphy_error.tex",
    "knots_triple.tex",
    "prime_knots.tex",
    "trefoil_moves.tex",
    "twistedpair_celtic.tex",
    "new_prime_knots.tex",
  }
  -- Copy example files
  errorlevel = cp("*.tex", "./examples", tmpdir)
  if errorlevel ~= 0 then
    error("** Error!!: Can't copy examples to ./"..tmpdir)
    return errorlevel
  else
    print("** Copying examples to ./"..tmpdir)
  end
  -- Compiling sample files
  print("Compiling sample files in ./"..tmpdir.." using [pdflatex]")
  for i, samples in ipairs(samples) do
     print("** Running: pdflatex "..samples)
    errorlevel = run(tmpdir, "pdflatex --shell-escape --interaction=batchmode "..samples)
    if errorlevel ~= 0 then
      error("** Error!!: pdflatex --shell-escape "..samples)
      return errorlevel
    end
  end
  -- Copy generated .pdf files to maindir
  print("Copy generated .pdf files to ./"..maindir)
  errorlevel = cp("*.pdf", tmpdir, maindir)
  if errorlevel ~= 0 then
    error("** Error!!: Can't copy generated pdf files to ./"..maindir)
    return errorlevel
  end
  -- If are OK then remove ./temp dir
  cleandir(tmpdir.."/knotdiagrams")
  cleandir(tmpdir)
  lfs.rmdir(tmpdir.."/knotdiagrams")
  lfs.rmdir(tmpdir)
  print("Remove temporary directory ./"..tmpdir)
  os.exit(0)
end
