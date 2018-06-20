FUNCTION map_l1b2_miss, misr_mode, misr_path, misr_orbit, misr_block, $
   DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function generates and saves a map of the missing
   ;  values for each of the 36 MISR L1B2 Georectified Radiance Product
   ;  (GRP) Terrain-Projected Top of Atmosphere (ToA) Radiance files
   ;  corresponding to a given MODE, PATH, ORBIT and BLOCK.
   ;
   ;  ALGORITHM: This function scans the 36 Radiance/RDQI fields contained
   ;  in the 9 L1B2 Georectified Radiance Product (GRP) Terrain-Projected
   ;  Top of Atmosphere Radiance files for the selected MODE, PATH, ORBIT
   ;  and BLOCK, and maps the various missing values.
   ;
   ;  SYNTAX:
   ;  rc = map_l1b2_miss, misr_mode, misr_path, misr_orbit, misr_block, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_mode {STRING} [I]: The selected MISR MODE.
   ;
   ;  *   misr_path {INTEGER} [I]: The selected MISR PATH number.
   ;
   ;  *   misr_orbit {LONG} [I]: The selected MISR ORBIT number.
   ;
   ;  *   misr_block {INTEGER} [I]: The selected MISR BLOCK number.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   DEBUG = debug {INT} [I] (Default value: 0): Flag to activate (1)
   ;      or skip (0) debugging tests.
   ;
   ;  *   EXCPT_COND = excpt_cond {STRING} [O] (Default value: ”):
   ;      Description of the exception condition if one has been
   ;      encountered, or a null string otherwise.
   ;
   ;  RETURNED VALUE TYPE: INTEGER.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns 0, and the output keyword parameter excpt_cond is set to
   ;      a null string, if the optional input keyword parameter DEBUG was
   ;      set and if the optional output keyword parameter EXCPT_COND was
   ;      provided in the call. This function generates and saves 37 files
   ;      in the folder
   ;      root_dirs[3] + ’/Pxxx_Oyyyyyy_Bzzz/L1B2_’ + misr_mode + ’/’:
   ;
   ;      -   1 plain text log file describing the inputs and outputs to
   ;          this function, named
   ;          map-log_Pxxx_Oyyyyyy_Bzzz_L1B2’ + misr_mode + ’MISS_[camera_name]_[acquis_date]_
   ;          [MISR-Version]_[creation-date].txt.
   ;
   ;      -   36 PNG files containing the maps of the missing values in
   ;          each of the spectral channels and for each camera, named
   ;          map_Pxxx_Oyyyyyy_Bzzz_L1B2’ + misr_mode + ’MISS_[camera_name]_[acquis_date]_
   ;          [MISR-Version]_[creation-date].png.
   ;
   ;      The color convention is:
   ;
   ;      -   YELLOW: Pixels obscured by topography.
   ;
   ;      -   BLUE: Pixels in the ocean.
   ;
   ;      -   DARK GRAY: Pixels on the edge of the swath.
   ;
   ;      -   RED: Pixels containing bad data.
   ;
   ;      -   BLACK: Pixels with nominal data.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The requested maps and the associated colorbars are
   ;      not saved.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input argument misr_mode is invalid.
   ;
   ;  *   Error 120: Input argument misr_path is invalid.
   ;
   ;  *   Error 130: Input argument misr_orbit is invalid.
   ;
   ;  *   Error 140: Input argument misr_block is invalid.
   ;
   ;  *   Error 199: Unrecognized computer: Update the function
   ;      set_root_dirs.
   ;
   ;  *   Error 210: An exception condition occurred in function
   ;      path2str.pro.
   ;
   ;  *   Error 220: An exception condition occurred in function
   ;      orbit2str.pro.
   ;
   ;  *   Error 230: An exception condition occurred in function
   ;      block2str.pro.
   ;
   ;  *   Error 240: An exception condition occurred in function
   ;      orbit2date.pro.
   ;
   ;  *   Error 310: An exception condition occurred in function
   ;      get_l1b2_files: Either too few or too many L1B2 GRP ToA GM
   ;      radiance files were found (9 are expected).
   ;
   ;  *   Error 320: An exception condition occurred in function
   ;      MTK_FILE_VERSION: Unable to retrieve the MISR L1B2 processing
   ;      version code from the file name.
   ;
   ;  *   Error 330: An exception condition occurred in function lr2hr
   ;      when upscaling the non-red channels of the off-nadir cameras.
   ;
   ;  *   Error 500: An exception condition occurred in function
   ;      is_writable.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
   ;
   ;  *   block2str.pro
   ;
   ;  *   get_l1b2_gm_files.pro
   ;
   ;  *   chk_misr_block.pro
   ;
   ;  *   chk_misr_mode.pro
   ;
   ;  *   chk_misr_orbit.pro
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   is_dir.pro
   ;
   ;  *   is_readable.pro
   ;
   ;  *   is_writable.pro
   ;
   ;  *   lr2hr.pro
   ;
   ;  *   orbit2date.pro
   ;
   ;  *   orbit2str.pro
   ;
   ;  *   path2str.pro
   ;
   ;  *   set_root_dirs.pro
   ;
   ;  *   strstr.pro
   ;
   ;  *   today.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function works equally well with GM and LM files.
   ;
   ;  EXAMPLES:
   ;
   ;      [Insert the command and its outcome]
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2016–04–26: Version 0.7 — Initial release under the name
   ;      map_l1b2_fill.
   ;
   ;  *   2017–07–20: Version 0.8 — Changed the function name to
   ;      map_l1b2_gm_fill.pro, upsized low resolution maps and updated
   ;      documentation.
   ;
   ;  *   2018–01–27: Version 0.9 — Changed the function name to
   ;      map_l1b2_gm_miss.pro, and updated documentation.
   ;
   ;  *   2018–01–30: Version 1.0 — Initial public release.
   ;
   ;  *   2018–03–04: Version 1.1 — Update the function to rely on
   ;      get_l1b2_gm_files.pro instead of chk_l1b2_gm_files.pro.
   ;
   ;  *   2018–04–08: Version 1.2 — Update this function to use
   ;      set_root_dirs.pro instead of set_misr_roots.pro.
   ;
   ;  *   2018–05–07: Version 1.3 — Merge this function with its twin
   ;      map_l1b2_lm_miss.pro and change the name to map_l1b2_miss.pro.
   ;
   ;  *   2018–05–14: Version 1.4 — Update this function to use the
   ;      revised version of is_writable.pro.
   ;
   ;  *   2018–05–18: Version 1.5 — Implement new coding standards.
   ;Sec-Lic
   ;  INTELLECTUAL PROPERTY RIGHTS
   ;
   ;  *   Copyright (C) 2017-2018 Michel M. Verstraete.
   ;
   ;      Permission is hereby granted, free of charge, to any person
   ;      obtaining a copy of this software and associated documentation
   ;      files (the “Software”), to deal in the Software without
   ;      restriction, including without limitation the rights to use,
   ;      copy, modify, merge, publish, distribute, sublicense, and/or
   ;      sell copies of the Software, and to permit persons to whom the
   ;      Software is furnished to do so, subject to the following
   ;      conditions:
   ;
   ;      The above copyright notice and this permission notice shall be
   ;      included in all copies or substantial portions of the Software.
   ;
   ;      THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
   ;      EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
   ;      OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
   ;      NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
   ;      HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
   ;      WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
   ;      FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
   ;      OTHER DEALINGS IN THE SOFTWARE.
   ;
   ;      See: https://opensource.org/licenses/MIT.
   ;
   ;  *   Feedback
   ;
   ;      Please send comments and suggestions to the author at
   ;      MMVerstraete@gmail.com.
   ;Sec-Cod

   ;  Get the name of this routine:
   info = SCOPE_TRACEBACK(/STRUCTURE)
   rout_name = info[N_ELEMENTS(info) - 1].ROUTINE

   ;  Initialize the default return code and the exception condition message:
   return_code = 0
   excpt_cond = ''

   ;  Set the default values of essential input keyword parameters:
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 4
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misr_mode, misr_path, misr_orbit, ' + $
            'misr_block.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the misr_mode argument is invalid:
      rc = chk_misr_mode(misr_mode, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the misr_path argument is invalid:
      rc = chk_misr_path(misr_path, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the misr_orbit argument is invalid:
      rc = chk_misr_orbit(misr_orbit, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the misr_block
   ;  argument is invalid:
      rc = chk_misr_block(misr_block, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the standard locations for MISR and MISR-HR files on this computer:
   root_dirs = set_root_dirs()
   IF ((debug) AND (root_dirs[0] EQ 'Unrecognized computer')) THEN BEGIN
      error_code = 199
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Unrecognized computer.'
      RETURN, error_code
   ENDIF

   ;  Get today's date:
   date = today(FMT = 'ymd')

   ;  Generate the string version of the MISR Path number:
   rc = path2str(misr_path, misr_path_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 210
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Generate the string version of the MISR Orbit number:
   rc = orbit2str(misr_orbit, misr_orbit_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 220
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Generate the string version of the MISR Block number:
   rc = block2str(misr_block, misr_block_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 230
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF
   pob_str = misr_path_str + '_' + misr_orbit_str + '_' + misr_block_str

   ;  Get the date of acquisition of this MISR Orbit:
   acquis_date = orbit2date(LONG(misr_orbit), DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF ((debug) AND (excpt_cond NE '')) THEN BEGIN
      error_code = 240
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Define the standard directory in which to save the maps and the log file:
   local_path = pob_str + PATH_SEP() + 'L1B2_' + misr_mode + PATH_SEP()
   map_path = root_dirs[3] + local_path

   ;  Return to the calling routine with an error message if the output
   ;  directory 'map_path' is not writable, and create it if it does not
   ;  exist:
   rc = is_writable(map_path, DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND ((rc EQ 0) OR (rc EQ -1))) THEN BEGIN
      error_code = 500
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF
   IF (rc EQ -2) THEN FILE_MKDIR, map_path

   ;  Identify the 9 L1B2 input files to map:
   ;  WARNING: This code fragment will prevent the generation of any map if the
   ;  number of L1B2 files is different from 9.
   rc = get_l1b2_files(misr_mode, misr_path, misr_orbit, l1b2_files, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 310
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF
   n_files = N_ELEMENTS(l1b2_files)

   ;  Retrieve the version number of the MISR L1B2 Global Mode files available,
   ;  assuming all files were generated with the same software version as the
   ;  first one:
   status = MTK_FILE_VERSION(l1b2_files[0], misr_version)
   IF ((debug) AND (status NE 0)) THEN BEGIN
      error_code = 320
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': MISR version number cannot be retrieved from input file ' + $
         l1b2_files[0]
      RETURN, error_code
   ENDIF

   ;  Generate the specification of the log file:
   log_fname = 'map-log_' + pob_str + '_L1B2' + misr_mode + 'MISS_' + acquis_date + '_' + $
      misr_version + '_' + date + '.txt'
   log_fspec = map_path + log_fname
   fmt1 = '(A14, A)'

   ;  Open the log file and start recording events:
   OPENW, log_unit, log_fspec, /GET_LUN
   PRINTF, log_unit, "File name: '", log_fname + "'", FORMAT = fmt1
   PRINTF, log_unit, "Folder name: ", $
      "root_dirs[3] + '" + local_path + "'", FORMAT = fmt1
   PRINTF, log_unit, 'Generated by: ', rout_name, FORMAT = fmt1
   PRINTF, log_unit, 'Saved on: ', date, FORMAT = fmt1
   PRINTF, log_unit

   PRINTF, log_unit, 'Date of MISR acquisition: ' + acquis_date
   PRINTF, log_unit

   PRINTF, log_unit, 'Content: Log file created in conjunction with ' + $
      'the generation of'
   PRINTF, log_unit, 'L1B2 GRP Terrain-projected ToA Global Mode MISS maps.'
   PRINTF, log_unit

   PRINTF, log_unit
   PRINTF, log_unit, 'Input L1B2 GM directory: ' + $
      FILE_DIRNAME(l1b2_files[0], /MARK_DIRECTORY)
   PRINTF, log_unit, 'misr_path  = ' + misr_path_str
   PRINTF, log_unit, 'misr_orbit = ' + misr_orbit_str
   PRINTF, log_unit, 'misr_block = ' + misr_block_str
   PRINTF, log_unit, 'misr_version = ' + misr_version
   PRINTF, log_unit, 'Output map_path directory: ' + map_path
   PRINTF, log_unit

   ;  Save the color coding in the log file:
   PRINTF, log_unit, 'Color coding convention:'
   PRINTF, log_unit, '   Yellow: Pixels obscured by topography.'
   PRINTF, log_unit, '   Blue: Pixels in the ocean.'
   PRINTF, log_unit, '   Dark grey: Pixels on the edge of the swath.'
   PRINTF, log_unit, '   Red: Pixels containing bad data.'
   PRINTF, log_unit, '   Black: Pixels with nominal data.'
   PRINTF, log_unit

   ;  Set the map prefix for the map filenames:
   map_fname1 = 'map_' + pob_str + '_L1B2GMMISS_'
   map_fname2 = acquis_date + '_' + misr_version + '_' + date + '.png'

   ;  Iterate over the 9 cameras (L1B2 GM files):
   n_cams = 9
   FOR i = 0, n_cams - 1 DO BEGIN

   ;  Determine the camera name for the current file name:
      parts = STRSPLIT(FILE_BASENAME(l1b2_files[i]), '_', /EXTRACT)
      cam = STRUPCASE(parts[7])
      PRINTF, log_unit, 'Mapping missing values of Camera ' + cam
      PRINTF, log_unit, '---------------------------------'
      PRINTF, log_unit

   ;  Iterate over the 4 spectral bands:
      n_bands = 4
      band_names = ['Blue', 'Green', 'Red', 'NIR']
      FOR j = 0, n_bands - 1 DO BEGIN

   ;  Set the name of the missing values map for this camera file:
         map_fspec = map_path + $
            map_fname1 + $
            cam + '-' + $
            band_names[j] + '_' + $
            map_fname2

   ;  Set the HDF grid name and field labels:
         grid = band_names[j] + 'Band'
         field = band_names[j] + ' Radiance/RDQI'

   ;  Open the HDF file and attach the required grid:
         fid = EOS_GD_OPEN(l1b2_files[i], /READ)
         gid = EOS_GD_ATTACH(fid, grid)

   ;  Read the radiance data:
         status = EOS_GD_READFIELD(gid, field, databuf)

   ;  Detach the grid and close the HDF file:
         status = EOS_GD_DETACH(gid)
         status = EOS_GD_CLOSE(fid)

   ;  Extract the scaled radiance data for the required Block (0-based in IDL),
   ;  where the integer division by 4 serves to remove the RDQI:
         block_data = databuf[*, *, misr_block - 1] / 4
         obsc = WHERE(block_data EQ 16377, nobsc)
         edge = WHERE(block_data EQ 16378, nedge)
         ocea = WHERE(block_data EQ 16379, nocea)
         badd = WHERE(block_data EQ 16380, nbadd)
         good = WHERE(block_data LT 16377, ngood)

   ;  Compute the number of pixels in the Block:
         IF ((misr_mode EQ 'LM') OR ((misr_mode EQ 'GM') AND $
            (cam EQ 'AN') OR (band_names[j] EQ 'Red'))) THEN BEGIN
            ncols = 2048L
            nlins = 512L
         ENDIF ELSE BEGIN
            ncols = 512L
            nlins = 128L
         ENDELSE
         all = ncols * nlins

   ;  Report on the number of missing values found and ensure all pixels have
   ;  been counted:
         PRINTF, log_unit, 'Data for Camera ' + cam + $
            ' and Band ' + band_names[j] + ':'
         PRINTF, log_unit, 'Npixl = ' + strstr(all)
         PRINTF, log_unit, 'Nobsc = ' + strstr(nobsc)
         PRINTF, log_unit, 'Nedge = ' + strstr(nedge)
         PRINTF, log_unit, 'Nocea = ' + strstr(nocea)
         PRINTF, log_unit, 'Nbadd = ' + strstr(nbadd)
         PRINTF, log_unit, 'Ngood = ' + strstr(ngood)
         sum = nobsc + nedge + nocea + nbadd + ngood
         IF (sum NE all) THEN BEGIN
            PRINTF, log_unit, '*** Warning ***:'
            PRINTF, log_unit, 'Sum of pixel type counts ' + strstr(sum) + $
               '  differs from total number of pixels in the L1B2 Block for'
            PRINTF, log_unit, 'MISR Path ' + misr_path_str + ', Orbit ' + $
               misr_orbit_str + ', Block ' + misr_block_str + ', Camera ' + $
               cam + ', Band ' + band_names[j]
         ENDIF
         PRINTF, log_unit

   ;  Define the array that will contain the map:
         missmap = BYTARR(ncols, nlins)

   ;  Set up colors for plotting: each (r, g, b) column defines a corresponding
   ;  intensity in the RGB channels:
         r = [  0, 255,   0,   0, 255,   0, 255, 255, 255, 100, 200]
         g = [  0,   0, 255,   0, 255, 255,   0, 255, 100, 100, 200]
         b = [  0,   0,   0, 255,   0, 255, 255, 255,   0, 100, 200]

         black = 0
         red = 1
         green = 2
         blue = 3
         yellow = 4
         cyan = 5
         purple = 6
         white = 7
         orange = 8
         lgrey = 9
         dgrey = 10

   ;  Assign colors to the various missing values:
         IF (nobsc GT 0) THEN missmap[obsc] = yellow
         IF (nocea GT 0) THEN missmap[ocea] = blue
         IF (nedge GT 0) THEN missmap[edge] = dgrey
         IF (nbadd GT 0) THEN missmap[badd] = red
         IF (ngood GT 0) THEN missmap[good] = black

   ;  If this is a low resolution map, upsize it to the full resolution to
   ;  facilitate comparisons:
         IF ((misr_mode EQ 'GM') AND (cam NE 'AN')) THEN BEGIN
            IF (band_names[j] NE 'Red') THEN BEGIN
               missmap = lr2hr(missmap, DEBUG = debug, EXCPT_COND = excpt_cond)
               IF ((debug) AND (excpt_cond NE '')) THEN BEGIN
                  error_code = 330
                  excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                     rout_name + excpt_cond
                  RETURN, error_code
               ENDIF
            ENDIF
         ENDIF

   ;  Write the PNG file:
         WRITE_PNG, map_fspec, missmap, r, g, b, /ORDER

         PRINTF, log_unit, 'The map of missing values for Camera ' + $
            cam + ', Band ' + band_names[j] + ' has been saved in'
         PRINTF, log_unit, map_fspec
         PRINTF, log_unit
      ENDFOR
      PRINT, 'Done Camera ' + cam
   ENDFOR

   FREE_LUN, log_unit
   CLOSE, /ALL
   PRINT, 'The outcome of this program is described in file ' + log_fspec

   RETURN, return_code

END
