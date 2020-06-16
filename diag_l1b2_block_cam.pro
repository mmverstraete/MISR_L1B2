FUNCTION diag_l1b2_block_cam, $
   l1b2_file, $
   misr_block, $
   meta_data, $
   HIST_IT = hist_it, $
   HIST_FOLDER = hist_folder, $
   VERBOSE = verbose, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function reports statistics on the distribution of
   ;  values found within the various fields of the various grids in a
   ;  single MISR BLOCK of a single, camera-specific, L1B2 Georectified
   ;  Radiance Product (GRP) Terrain-projected Top of Atmosphere (ToA)
   ;  Global Mode (GM) or Local Mode (LM) Radiance file. Specifically, for
   ;  each defined field of each defined HDF-EOS grid within that file,
   ;  hence in each of the 4 spectral bands, this function reports on
   ;
   ;  *   the total number pixels in the BLOCK,
   ;
   ;  *   the number of valid pixels,
   ;
   ;  *   the numbers of fill values of different types,
   ;
   ;  *   the minimum and maximum values of the 2 radiance fields (scaled
   ;      and unscaled) as well as of the reflectance field.
   ;
   ;  If the optional keyword parameter HIST_IT is set, this function also
   ;  generates histograms of the ToA BRF values found in each spectral
   ;  data channel and saves them in the default or specified output
   ;  folder.
   ;
   ;  ALGORITHM: This function scans the designated L1B2 Georectified
   ;  Radiance Product (GRP) Terrain-Projected Top of Atmosphere (ToA)
   ;  Global Mode (GM) or Local Mode (LM) Radiance file and tallies the
   ;  various types of pixel values with the WHERE, MIN and MAX functions.
   ;
   ;  SYNTAX: rc = diag_l1b2_block_cam(l1b2_file, misr_block, meta_data, $
   ;  HIST_IT = hist_it, HIST_FOLDER = hist_folder, $
   ;  VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   l1b2_file {STRING} [I]: The full specification (path and
   ;      filename) of a MISR L1B2 GRP ToA GM or LM radiance file (i.e.,
   ;      for a single camera).
   ;
   ;  *   misr_block {INTEGER} [I]: The MISR BLOCK number to be inspected
   ;      within that file.
   ;
   ;  *   meta_data {STRUCTURE} [O]: Metadata about the valid or fill
   ;      radiance data values contained in the selected BLOCK, for each
   ;      of the 4 spectral bands.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   HIST_IT = hist_it {INT} [I] (Default value: 0): Flag to activate
   ;      (1) or skip (0) generating histograms of the numerical results.
   ;
   ;  *   HIST_FOLDER = hist_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the output folder
   ;      containing the histograms.
   ;
   ;  *   VERBOSE = verbose {INT} [I] (Default value: 0): Flag to enable
   ;      (> 0) or skip (0) reporting progress on the console: 1 only
   ;      reports exiting the routine; 2 reports entering and exiting the
   ;      routine, as well as key milestones; 3 reports entering and
   ;      exiting the routine, and provides detailed information on the
   ;      intermediary results.
   ;
   ;  *   DEBUG = debug {INT} [I] (Default value: 0): Flag to activate (1)
   ;      or skip (0) debugging tests.
   ;
   ;  *   EXCPT_COND = excpt_cond {STRING} [O] (Default value: ”):
   ;      Description of the exception condition if one has been
   ;      encountered, or a null string otherwise.
   ;
   ;  RETURNED VALUE TYPE: INT.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns 0, and the output keyword parameter excpt_cond is set to
   ;      a null string, if the optional input keyword parameter DEBUG was
   ;      set and if the optional output keyword parameter EXCPT_COND was
   ;      provided in the call. The output positional parameter meta_data
   ;      contains a structure with the desired information. If the
   ;      optional input keyword parameter HIST_IT is set in the call,
   ;      this function will generate 4 histograms of the BRF values found
   ;      in the data channels for the current camera. These histograms
   ;      are named
   ;      Hist_L1B2_diag_ + [mpob_str] + ’-’ + [misr_camera] + ’-’ + $
   ;      [misr_band] + ’_’ + [acquis_date] + ’_’ + [date] + ’.png’ and
   ;      located in the default or specified folder.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The structure meta_data is not created and the
   ;      histograms are not saved.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter l1b2_file is not found,
   ;      not a regular file or not readable.
   ;
   ;  *   Error 120: The input positional parameter misr_block is invalid.
   ;
   ;  *   Error 199: An exception condition occurred in
   ;      set_roots_vers.pro.
   ;
   ;  *   Error 200: An exception condition occurred in orbit2date.pro.
   ;
   ;  *   Error 210: An exception condition occurred in path2str.pro.
   ;
   ;  *   Error 220: An exception condition occurred in orbit2str.pro.
   ;
   ;  *   Error 230: An exception condition occurred in block2str.pro.
   ;
   ;  *   Error 299: The computer is not recognized and the optional input
   ;      keyword parameter hist_folder is not specified.
   ;
   ;  *   Error 400: The output folder hist_fpath is unwritable.
   ;
   ;  *   Error 500: The array
   ;
   ;  *   Error 600: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_SETREGION_BY_PATH_BLOCKRANGE.
   ;
   ;  *   Error 610: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_FILE_TO_GRIDLIST.
   ;
   ;  *   Error 620: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_FILE_GRID_TO_FIELDLIST.
   ;
   ;  *   Error 630: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_READDATA.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
   ;
   ;  *   block2str.pro
   ;
   ;  *   chk_misr_block.pro
   ;
   ;  *   force_path_sep.pro
   ;
   ;  *   hr2lr.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   is_readable_file.pro
   ;
   ;  *   is_writable_dir.pro
   ;
   ;  *   orbit2date.pro
   ;
   ;  *   orbit2str.pro
   ;
   ;  *   path2str.pro
   ;
   ;  *   set_roots_vers.pro.
   ;
   ;  *   strcat.pro
   ;
   ;  *   strstr.pro
   ;
   ;  *   today.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: If the optional input keyword parameter hist_it is set,
   ;      this function generates 4 histograms, 1 for each spectral data
   ;      channel of the L1B2 GRP ToA radiance input file.
   ;
   ;  *   NOTE 2: All data channels available at the full native spatial
   ;      resolution of the MISR instrument are downscaled to 512 × 128
   ;      for the purpose of plotting the histograms to limit the number
   ;      of points in the graph.
   ;
   ;  EXAMPLES:
   ;
   ;      See the documentation for the functions
   ;         diag_l1b2gm.pro and diag_l1b2lm.pro.
   ;
   ;  REFERENCES:
   ;
   ;  *   Michel M. Verstraete, Linda A. Hunt and Veljko M.
   ;      Jovanovic (2019) Improving the usability of the MISR L1B2
   ;      Georectified Radiance Product (2000–present) in land surface
   ;      applications, _Earth System Science Data Discussions (ESSDD)_,
   ;      Vol. 2019, p. 1–31, available from
   ;      https://www.earth-syst-sci-data-discuss.net/essd-2019-210/ (DOI:
   ;      10.5194/essd-2019-210).
   ;
   ;  *   Michel M. Verstraete, Linda A. Hunt and Veljko M.
   ;      Jovanovic (2020) Multi-angle Imaging SpectroRadiometer (MISR)
   ;      L1B2 Georectified Radiance Product (2000–present) in land surface
   ;      applications, _Earth System Science Data (ESSD)_, Vol. 12,
   ;      p. 1321-1346, available from
   ;      https://www.earth-syst-sci-data-discuss.net/essd-2019-210/
   ;      (DOI: 10.5194/essd-12-1321-2020).
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–07–12: Version 0.8 — Initial release under the name
   ;      diag_l1b2_block.
   ;
   ;  *   2017–10–10: Version 0.9 — Changed the name of the function to
   ;      diag_l1b2_gm_block.pro.
   ;
   ;  *   2018–01–30: Version 1.0 — Initial public release.
   ;
   ;  *   2018–06–01: Version 1.1 — Merge this function with its twin
   ;      diag_l1b2_lm_block.pro and change the name back to
   ;      diag_l1b2_block.pro.
   ;
   ;  *   2018–06–07: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2018–07–07: Version 1.6 — Update this routine to report on the
   ;      location of pixels with an RDQI value of 2.
   ;
   ;  *   2018–11–30: Version 1.7 — Change the name of the function to
   ;      diag_l1b2_block_cam for consistency, update the documentation.
   ;
   ;  *   2019–03–01: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–03–20: Version 2.10 — Update the handling of the optional
   ;      input keyword parameter VERBOSE and generate the software
   ;      version consistent with the published documentation.
   ;
   ;  *   2019–04–12: Version 2.11 — Add code to set the BUFFER keyword
   ;      parameter as a function of the VERBOSE keyword parameter.
   ;
   ;  *   2019–05–02: Version 2.12 — Bug fix: Encapsulate folder and file
   ;      creation in IF statements.
   ;
   ;  *   2019–05–04: Version 2.13 — Update the code to report the
   ;      specific error message of MTK routines.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the use of
   ;      verbose and the assignment of numeric return codes), and switch
   ;      to 3-parts version identifiers.
   ;
   ;  *   2019–10–24: Version 2.1.1 — Update the code to save the
   ;      histograms in a folder consistent with the rest of the L1B2
   ;      processing routines.
   ;
   ;  *   2020–03–25: Version 2.1.2 — Update the code to reduce the
   ;      dimension of the data set to plot as a histogram when handling
   ;      LM or high spatial resolution data channels; delete code
   ;      fragments to record the locations of missing and poor values
   ;      (due to excessive time required); update the documentation.
   ;
   ;  *   2020–03–30: Version 2.1.5 — Software version described in the
   ;      preprint published in _ESSDD_ referenced above.
   ;
   ;  *   2020–05–10: Version 2.1.7 — Software version described in the
   ;      peer-reviewed paper published in _ESSD_ referenced above.
   ;Sec-Lic
   ;  INTELLECTUAL PROPERTY RIGHTS
   ;
   ;  *   Copyright (C) 2017-2020 Michel M. Verstraete.
   ;
   ;      Permission is hereby granted, free of charge, to any person
   ;      obtaining a copy of this software and associated documentation
   ;      files (the “Software”), to deal in the Software without
   ;      restriction, including without limitation the rights to use,
   ;      copy, modify, merge, publish, distribute, sublicense, and/or
   ;      sell copies of the Software, and to permit persons to whom the
   ;      Software is furnished to do so, subject to the following three
   ;      conditions:
   ;
   ;      1. The above copyright notice and this permission notice shall
   ;      be included in their entirety in all copies or substantial
   ;      portions of the Software.
   ;
   ;      2. THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY
   ;      KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
   ;      WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
   ;      AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
   ;      HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
   ;      WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
   ;      FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
   ;      OTHER DEALINGS IN THE SOFTWARE.
   ;
   ;      See: https://opensource.org/licenses/MIT.
   ;
   ;      3. The current version of this Software is freely available from
   ;
   ;      https://github.com/mmverstraete.
   ;
   ;  *   Feedback
   ;
   ;      Please send comments and suggestions to the author at
   ;      MMVerstraete@gmail.com
   ;Sec-Cod

   COMPILE_OPT idl2, HIDDEN

   ;  Get the name of this routine:
   info = SCOPE_TRACEBACK(/STRUCTURE)
   rout_name = info[N_ELEMENTS(info) - 1].ROUTINE

   ;  Initialize the default return code:
   return_code = 0

   ;  Set the default values of flags and essential output keyword parameters:
   IF (KEYWORD_SET(hist_it)) THEN hist_it = 1 ELSE hist_it = 0
   IF (KEYWORD_SET(verbose)) THEN BEGIN
      IF (is_numeric(verbose)) THEN verbose = FIX(verbose) ELSE verbose = 0
      IF (verbose LT 0) THEN verbose = 0
      IF (verbose GT 3) THEN verbose = 3
   ENDIF ELSE verbose = 0
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   ;  Control the amount of output on the console during processing: Setting
   ;  'buffer' to 1 prevents outputting the histogram plots on the screen,
   ;  though they are still generated in memory and saved in output files:
   IF (verbose GT 1) THEN PRINT, 'Entering ' + rout_name + '.'
   IF (verbose LT 3) THEN buffer = 1 ELSE buffer = 0

   ;  Initialize the output positional parameter(s):
   meta_data = {}

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 3
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): l1b2_file, misr_block, meta_data.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'l1b2_file' is not a regular file:
      res = is_readable_file(l1b2_file)
      IF (res EQ 0) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
            rout_name + ': The input file ' + l1b2_file + $
            ' is not found, not a regular file or not readable.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_block' is invalid:
      rc = chk_misr_block(misr_block, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the default folders and version identifiers of the MISR and
   ;  MISR-HR files on this computer, and return to the calling routine if
   ;  there is an internal error, but not if the computer is unrecognized, as
   ;  root addresses can be overridden by input keyword parameters:
   rc_roots = set_roots_vers(root_dirs, versions, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc_roots GE 100)) THEN BEGIN
      error_code = 199
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Get today's date:
   date = today(FMT = 'ymd')

   ;  Retrieve the MISR Path, Orbit, Camera and Version information from the
   ;  filename:
   parts = STRSPLIT(FILE_BASENAME(l1b2_file), '_', /EXTRACT)
   misr_mode = parts[4]
   misr_path = FIX(STRMID(parts[5], 1, 3))
   misr_orbit = LONG(STRMID(parts[6], 1, 6))
   misr_camera = parts[7]
   misr_version = parts[8] + '_' + STRMID(parts[9], 0, 4)

   ;  Get the date of acquisition of this MISR Orbit:
   acquis_date = orbit2date(misr_orbit, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF (debug AND (excpt_cond NE '')) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  If the histograms have been requested, generate the long string versions
   ;  of misr_path, misr_orbit and misr_block (used in the plots' titles and
   ;  file names:
   IF (hist_it) THEN BEGIN
      IF (verbose GT 2) THEN PRINT, 'Readying for histograms.'

      rc = path2str(misr_path, misr_path_str, DEBUG = debug, $
         EXCPT_COND = excpt_cond)
      IF (debug AND (rc NE 0)) THEN BEGIN
         error_code = 210
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
      rc = orbit2str(misr_orbit, misr_orbit_str, DEBUG = debug, $
         EXCPT_COND = excpt_cond)
      IF (debug AND (rc NE 0)) THEN BEGIN
         error_code = 220
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
      rc = block2str(misr_block, misr_block_str, DEBUG = debug, $
         EXCPT_COND = excpt_cond)
      IF (debug AND (rc NE 0)) THEN BEGIN
         error_code = 230
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
      pob_str = strcat([misr_path_str, misr_orbit_str, misr_block_str], '-')
      mpob_str = strcat([misr_mode, pob_str], '-')
   ENDIF

   ;  Return to the calling routine with an error message if the routine
   ;  'set_roots_vers.pro' could not assign valid values to the array root_dirs
   ;  and the required MISR and MISR-HR root folders have not been initialized:
   IF (debug AND (rc_roots EQ 99)) THEN BEGIN
      IF (hist_it AND (~KEYWORD_SET(hist_folder))) THEN BEGIN
         error_code = 299
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond + ' And the optional input keyword ' + $
            'parameter hist_folder is not specified.'
         RETURN, error_code
      ENDIF
   ENDIF

   IF (hist_it) THEN BEGIN

   ;  Set the directory address of the folder containing the output histogram
   ;  files, if it has not been set previously:
      IF (KEYWORD_SET(hist_folder)) THEN BEGIN
         hist_fpath = hist_folder
      ENDIF ELSE BEGIN
         hist_fpath = root_dirs[3] + pob_str + PATH_SEP() + misr_mode + $
            PATH_SEP() + 'L1B2' + PATH_SEP() + 'Histograms' + PATH_SEP()
      ENDELSE
      rc = force_path_sep(hist_fpath)

   ;  Return to the calling routine with an error message if the output
   ;  directory 'hist_fpath' is not writable, and create it if it does not
   ;  exist:
      res = is_writable_dir(hist_fpath, /CREATE)
      IF (debug AND (res NE 1)) THEN BEGIN
         error_code = 400
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
            rout_name + ': The output folder hist_fpath is unwritable.'
         RETURN, error_code
      ENDIF
   ENDIF

   IF (verbose GT 2) THEN PRINT, 'hist_fpath = >' + hist_fpath + '<'

   ;  Create the output meta_data structure:
   meta_data = CREATE_STRUCT('Title', $
      'Metadata for a single Block of a single MISR L1B2 GM file')
   meta_data = CREATE_STRUCT(meta_data, 'OS_Path', FILE_DIRNAME(l1b2_file))
   meta_data = CREATE_STRUCT(meta_data, 'OS_File', FILE_BASENAME(l1b2_file))
   meta_data = CREATE_STRUCT(meta_data, 'MISR_Mode', misr_mode)
   meta_data = CREATE_STRUCT(meta_data, 'MISR_Path', misr_path)
   meta_data = CREATE_STRUCT(meta_data, 'MISR_Orbit', misr_orbit)
   meta_data = CREATE_STRUCT(meta_data, 'MISR_Block', misr_block)
   meta_data = CREATE_STRUCT(meta_data, 'MISR_Camera', misr_camera)
   meta_data = CREATE_STRUCT(meta_data, 'MISR_Version', misr_version)

   ;  Define the (1-Block) region of interest:
   status = MTK_SETREGION_BY_PATH_BLOCKRANGE(misr_path, $
      misr_block, misr_block, region)
   IF (debug AND (status NE 0)) THEN BEGIN
      error_code = 600
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Error message from MTK_SETREGION_BY_PATH_BLOCKRANGE: ' + $
         MTK_ERROR_MESSAGE(status)
      RETURN, error_code
   ENDIF

   ;  Retrieve the names of the grids:
   status = MTK_FILE_TO_GRIDLIST(l1b2_file, ngrids, grids)
   IF (debug AND (status NE 0)) THEN BEGIN
      error_code = 610
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Error message from MTK_FILE_TO_GRIDLIST: ' + $
         MTK_ERROR_MESSAGE(status)
      RETURN, error_code
   ENDIF
   meta_data = CREATE_STRUCT(meta_data, 'Ngrids', ngrids)

   ;  For each grid, record its name:
   FOR i = 0, ngrids - 1 DO BEGIN
      tagg = 'Grid_' + strstr(i)
      valg = grids[i]
      meta_data = CREATE_STRUCT(meta_data, tagg, valg)
      IF (verbose GT 2) THEN PRINT, 'Start processing grid ' + grids[i]

   ;  Retrieve the names of the fields in this grid:
      status = MTK_FILE_GRID_TO_FIELDLIST(l1b2_file, grids[i], $
         nfields, fields)
      IF (debug AND (status NE 0)) THEN BEGIN
         error_code = 620
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Error message from MTK_FILE_GRID_TO_FIELDLIST: ' + $
            MTK_ERROR_MESSAGE(status)
         RETURN, error_code
      ENDIF

      tagnf = tagg + '_Nfields'
      valnf = nfields
      meta_data = CREATE_STRUCT(meta_data, tagnf, valnf)

   ;  For each field, record its name:
      FOR j = 0, nfields - 1 DO BEGIN
         tagfn = tagg + '_Field_' + strstr(j)
         valfn = fields[j]
         meta_data = CREATE_STRUCT(meta_data, tagfn, valfn)
         IF (verbose GT 2) THEN PRINT, 'Start processing field ' + fields[j]

   ;  Read the data for that grid and field:
         status = MTK_READDATA(l1b2_file, grids[i], fields[j], region, $
            databuf, mapinfo)
         IF (status NE 0) THEN BEGIN
            error_code = 630
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Error message from MTK_READDATA: ' + $
               MTK_ERROR_MESSAGE(status)
            RETURN, error_code
         ENDIF

   ;  Count the total number of pixels in that field:
         npixels = N_ELEMENTS(databuf)
         tagnp = tagfn + '_Npixels'
         valnp = npixels
         meta_data = CREATE_STRUCT(meta_data, tagnp, valnp)

   ;  Report on the field data type:
         type = SIZE(databuf, /TYPE)
         tagty = tagfn + '_IDLType'
         valty = type
         meta_data = CREATE_STRUCT(meta_data, tagty, valty)

   ;  Field-specific processing:
   ;  Process fields whose names include both 'Radiance' and 'RDQI':
         IF ((STRPOS(fields[j], 'Radiance') GE 0) AND $
            (STRPOS(fields[j], 'RDQI') GE 0)) THEN BEGIN

   ;  Retrieve the current spectral band:
            parts = STRSPLIT(fields[j], ' ', /EXTRACT)
            misr_band = parts[0]

   ;  Count the number of obscured pixels in that field:
            idx_obs = WHERE(databuf EQ 65511, nobsc)
            tagnobs = tagfn + '_Nobsc'
            valnobs = nobsc
            meta_data = CREATE_STRUCT(meta_data, tagnobs, valnobs)

   ;  Count the number of edge pixels in that field:
            idx_edg = WHERE(databuf EQ 65515, nedge)
            tagnedg = tagfn + '_Nedge'
            valnedg = nedge
            meta_data = CREATE_STRUCT(meta_data, tagnedg, valnedg)

   ;  Count the number of ocean pixels in that field:
            idx_oce = WHERE(databuf EQ 65519, nocean)
            tagnoce = tagfn + '_Nocean'
            valnoce = nocean
            meta_data = CREATE_STRUCT(meta_data, tagnoce, valnoce)

   ;  Count the number of 'bad' pixels (RDQI = 3) in that field:
            idx_bad = WHERE(databuf EQ 65523, nbad)
            tagnbad = tagfn + '_Nbad'
            valnbad = nbad
            meta_data = CREATE_STRUCT(meta_data, tagnbad, valnbad)

   ;  Count the number of 'good' pixels:
            idx_gud = WHERE(databuf LT 65511, ngud)
            tagngud = tagfn + '_Ngud'
            valngud = ngud
            meta_data = CREATE_STRUCT(meta_data, tagngud, valngud)

   ;  Record the ranks of the first and last samples on the first line of that
   ;  Block that are not fill values (65515):
            sz = SIZE(databuf, /DIMENSIONS)
            n_samples = sz[0]
            n_lines = sz[1]
            line1 = UINTARR(sz[0])
            line1 = databuf[*, 0]
            fst_dat1 = 0
            REPEAT BEGIN
               fst_dat1 = fst_dat1 + 1
            ENDREP UNTIL (line1[fst_dat1] NE 65515)
            lst_dat1 = N_ELEMENTS(line1)
            REPEAT BEGIN
               lst_dat1 = lst_dat1 - 1
            ENDREP UNTIL (line1[lst_dat1] NE 65515)
            tagrank1gud1 = tagfn + '_FstGudL1'
            meta_data = CREATE_STRUCT(meta_data, tagrank1gud1, fst_dat1)
            tagrank1gudn = tagfn + '_LstGudL1'
            meta_data = CREATE_STRUCT(meta_data, tagrank1gudn, lst_dat1)

   ;  Compute and output the effective swath width:
            IF ((misr_mode EQ 'GM') AND $
               ((misr_camera NE 'AN') AND (misr_band NE 'Red'))) THEN BEGIN
               sp_res = 1100.0
            ENDIF ELSE BEGIN
               sp_res = 275.0
            ENDELSE
            swath = (lst_dat1 - fst_dat1) * sp_res
            tagswath = tagfn + '_EffSwath'
            meta_data = CREATE_STRUCT(meta_data, tagswath, swath)
         ENDIF

   ;  Process fields whose names include 'Radiance' but not 'RDQI':
         IF ((STRPOS(fields[j], 'Radiance') GE 0) AND $
            (STRPOS(fields[j], 'RDQI') LT 0)) THEN BEGIN

   ;  Count the number of zero-valued pixels in that field:
            idx_zer = WHERE(databuf EQ 0.0, nzero)
            tagnzero = tagfn + '_Nzero'
            valnzero = nzero
            meta_data = CREATE_STRUCT(meta_data, tagnzero, valnzero)

   ;  Count the number of strictly positive-valued pixels in that
   ;  field:
            idx_pos = WHERE(databuf GT 0.0, nposi)
            tagnposi = tagfn + '_Nposi'
            valnposi = nposi
            meta_data = CREATE_STRUCT(meta_data, tagnposi, valnposi)
         ENDIF

   ;  Process fields whose names include 'RDQI' but not 'Radiance':
         IF ((STRPOS(fields[j], 'Radiance') LT 0) AND $
            (STRPOS(fields[j], 'RDQI') GE 0)) THEN BEGIN

   ;  Count the number of pixels with (RDQI = 0) in that field:
            idx_rd0 = WHERE(databuf EQ 0, nrdqi0)
            tag0 = tagfn + '_RDQI0'
            val0 = nrdqi0
            meta_data = CREATE_STRUCT(meta_data, tag0, val0)

   ;  Count the number of pixels with (RDQI = 1) in that field:
            idx_rd1 = WHERE(databuf EQ 1, nrdqi1)
            tag1 = tagfn + '_RDQI1'
            val1 = nrdqi1
            meta_data = CREATE_STRUCT(meta_data, tag1, val1)

   ;  Count the number of pixels with (RDQI = 2) in that field:
            idx_rd2 = WHERE(databuf EQ 2, nrdqi2)
            tag2 = tagfn + '_RDQI2'
            val2 = nrdqi2
            meta_data = CREATE_STRUCT(meta_data, tag2, val2)

   ;  Count the number of pixels with (RDQI = 3) in that field:
            idx_rd3 = WHERE(databuf EQ 3, nrdqi3)
            tag3 = tagfn + '_RDQI3'
            val3 = nrdqi3
            meta_data = CREATE_STRUCT(meta_data, tag3, val3)
         ENDIF

   ;  Process fields whose names include 'DN':
         IF (STRPOS(fields[j], 'DN') GE 0) THEN BEGIN
            maxdn = MAX(databuf, MIN = mindn)
            tagdnmin = tagfn + '_DN_Min'
            valdnmin = mindn
            meta_data = CREATE_STRUCT(meta_data, tagdnmin, valdnmin)
            tagdnmax = tagfn + '_DN_Max'
            valdnmax = maxdn
            meta_data = CREATE_STRUCT(meta_data, tagdnmax, valdnmax)
         ENDIF

   ;  Process fields whose names include 'Reflectance':
         IF (STRPOS(fields[j], 'Reflectance') GE 0) THEN BEGIN
            idx_ref = WHERE(databuf GT 0.0, n_ref_gud)
            tagrgud = tagfn + '_NRefGud'
            valrgud = n_ref_gud
            meta_data = CREATE_STRUCT(meta_data, tagrgud, valrgud)
            maxref = MAX(databuf, MIN = minref)
            tagrmin = tagfn + '_Refl_Min'
            valrmin = minref
            meta_data = CREATE_STRUCT(meta_data, tagrmin, valrmin)
            tagrmax = tagfn + '_Refl_Max'
            valrmax = maxref
            meta_data = CREATE_STRUCT(meta_data, tagrmax, valrmax)
         ENDIF

   ;  Process fields whose names include 'Brf':
         IF (STRPOS(fields[j], 'Brf') GE 0) THEN BEGIN
            idx_brf = WHERE(databuf GT 0.0, n_brf_gud)
            tagbgud = tagfn + '_NBrfGud'
            valbgud = n_brf_gud
            meta_data = CREATE_STRUCT(meta_data, tagbgud, valbgud)
            maxbrf = MAX(databuf[idx_brf], MIN = minbrf)
            tagbmin = tagfn + '_Brf_Min'
            valbmin = minbrf
            meta_data = CREATE_STRUCT(meta_data, tagbmin, valbmin)
            tagbave = tagfn + '_Average'
            valbave = TOTAL(databuf[idx_brf]) / n_brf_gud
            meta_data = CREATE_STRUCT(meta_data, tagbave, valbave)
            tagbstd = tagfn + '_STD'
            valbstd = STDDEV(databuf[idx_brf])
            meta_data = CREATE_STRUCT(meta_data, tagbstd, valbstd)
            tagbmax = tagfn + '_Brf_Max'
            valbmax = maxbrf
            meta_data = CREATE_STRUCT(meta_data, tagbmax, valbmax)
            tagbskew = tagfn + '_Skewness'
            valbskew = SKEWNESS(databuf[idx_brf])
            meta_data = CREATE_STRUCT(meta_data, tagbskew, valbskew)
            tagbkurt = tagfn + '_Kurtosis'
            valbkurt = KURTOSIS(databuf[idx_brf])
            meta_data = CREATE_STRUCT(meta_data, tagbkurt, valbkurt)

   ;  If the histogram option has been set, plot the histogram of the values
   ;  in this channel:
            IF (hist_it) THEN BEGIN
               hist = HISTOGRAM(databuf[idx_brf], $
                  MIN = 0.0, $
                  MAX = maxbrf, $
                  BINSIZE = 0.005, $
                  LOCATIONS = locations)
               title = 'L1B2 GRP ' + misr_mode + ' histogram for ' + $
                  misr_path_str + ', ' + $
                  misr_orbit_str + ', ' + $
                  misr_block_str + ', ' + $
                  misr_camera + ', ' + fields[j]
               temp1 = STRSPLIT(fields[j], ' ', /EXTRACT)
               temp2 = temp1[0] + '-' + temp1[1]
               hname = 'Hist_L1B2_diag_' + $
                  mpob_str + '-' + $
                  misr_camera + '-' + $
                  temp2 + '_' + $
                  acquis_date + '_' + $
                  date + '.png'
               hist_plot = PLOT(locations, hist, $
                  XRANGE = maxbrf, $
                  XTITLE = 'L1B2 GRP ' + misr_mode + ' Brf', $
                  YTITLE = 'Number of pixels', $
                  TITLE = title, $
                  /HISTOGRAM, $
                  BUFFER = buffer)
               my_npts = TEXT( $
                  0.95 * hist_plot.XRANGE[1], $
                  0.90 * hist_plot.YRANGE[1], $
                  ALIGNMENT = 1.0, $
                  FONT_SIZE = 10, $
                  /DATA, $
                  TARGET = HIST_PLOT, $
                  'n_pts = ' + strstr(n_brf_gud))
               disp_str = strstr(round_dec(minbrf, 4))
               disp_pos = STRPOS(disp_str, '.')
               disp_min = STRMID(disp_str, 0, $
                  disp_pos + MIN([5, STRLEN(disp_str) - disp_pos]))
               my_min = TEXT( $
                  0.95 * hist_plot.XRANGE[1], $
                  0.85 * hist_plot.YRANGE[1], $
                  ALIGNMENT = 1.0, $
                  FONT_SIZE = 10, $
                  /DATA, $
                  TARGET = HIST_PLOT, $
                  'min_Brf = ' + disp_min)
               disp_str = strstr(round_dec(valbave, 4))
               disp_pos = STRPOS(disp_str, '.')
               disp_ave = STRMID(disp_str, 0, $
                  disp_pos + MIN([5, STRLEN(disp_str) - disp_pos]))
               my_ave = TEXT( $
                  0.95 * hist_plot.XRANGE[1], $
                  0.80 * hist_plot.YRANGE[1], $
                  ALIGNMENT = 1.0, $
                  FONT_SIZE = 10, $
                  /DATA, $
                  TARGET = HIST_PLOT, $
                  'ave_Brf = ' + disp_ave)
               disp_str = strstr(round_dec(valbstd, 4))
               disp_pos = STRPOS(disp_str, '.')
               disp_std = STRMID(disp_str, 0, $
                  disp_pos + MIN([5, STRLEN(disp_str) - disp_pos]))
               my_std = TEXT( $
                  0.95 * hist_plot.XRANGE[1], $
                  0.75 * hist_plot.YRANGE[1], $
                  ALIGNMENT = 1.0, $
                  FONT_SIZE = 10, $
                  /DATA, $
                  TARGET = HIST_PLOT, $
                  'std_Brf = ' + disp_std)
               disp_str = strstr(round_dec(maxbrf, 4))
               disp_pos = STRPOS(disp_str, '.')
               disp_max = STRMID(disp_str, 0, $
                  disp_pos + MIN([5, STRLEN(disp_str) - disp_pos]))
               my_max = TEXT( $
                  0.95 * hist_plot.XRANGE[1], $
                  0.70 * hist_plot.YRANGE[1], $
                  ALIGNMENT = 1.0, $
                  FONT_SIZE = 10, $
                  /DATA, $
                  TARGET = HIST_PLOT, $
                  'max_Brf = ' + disp_max)
               disp_str = strstr(round_dec(valbskew, 4))
               disp_pos = STRPOS(disp_str, '.')
               disp_skew = STRMID(disp_str, 0, $
                  disp_pos + MIN([5, STRLEN(disp_str) - disp_pos]))
               my_skew = TEXT( $
                  0.95 * hist_plot.XRANGE[1], $
                  0.65 * hist_plot.YRANGE[1], $
                  ALIGNMENT = 1.0, $
                  FONT_SIZE = 10, $
                  /DATA, $
                  TARGET = HIST_PLOT, $
                  'skew_Brf = ' + disp_skew)
               disp_str = strstr(round_dec(valbkurt, 4))
               disp_pos = STRPOS(disp_str, '.')
               disp_kurt = STRMID(disp_str, 0, $
                  disp_pos + MIN([5, STRLEN(disp_str) - disp_pos]))
               my_kurt = TEXT( $
                  0.95 * hist_plot.XRANGE[1], $
                  0.60 * hist_plot.YRANGE[1], $
                  ALIGNMENT = 1.0, $
                  FONT_SIZE = 10, $
                  /DATA, $
                  TARGET = HIST_PLOT, $
                  'kurt_Brf = ' + disp_kurt)
               hist_plot.save, hist_fpath + hname
               hist_plot.close
               IF (verbose GT 0) THEN PRINT, 'Histogram saved in ' + $
                  hist_fpath + hname
            ENDIF
         ENDIF
      ENDFOR
   ENDFOR

   IF (verbose GT 1) THEN PRINT, 'Exiting ' + rout_name + '.'

   RETURN, return_code

END
