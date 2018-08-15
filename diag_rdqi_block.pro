FUNCTION diag_rdqi_block, l1b2_file, misr_block, meta_data, $
   DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function collects and stores statistical about the
   ;  types and quality of radiance values in MISR L1B2 files.
   ;
   ;  ALGORITHM: This program/function [how the routine does it]...
   ;
   ;  SYNTAX: rc = diag_rdqi_block(l1b2_file, misr_block, meta_data, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   l1b2_file {STRING} [I]: The name of a MISR L1B2 file to be
   ;      inspected.
   ;
   ;  *   misr_block {INTEGER} [I]: The MISR BLOCK number to be inspected
   ;      within that file.
   ;
   ;  *   meta_data {STRUCTURE} [O]: The output structure containing the
   ;      results of the inspection.
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
   ;      a null string, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided in the call. The output positional parameter meta_data
   ;      contains statistical information about the prevalence of various
   ;      types of values, in particular with RDQI flags of 0 to 3.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameter meta_data may be
   ;      undefined, inexistent, incomplete or useless.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter l1b2_file is unreadable.
   ;
   ;  *   Error 120: Input argument misr_block is invalid.
   ;
   ;  *   Error 200: An exception condition occurred in orbit2date.pro.
   ;
   ;  *   Error 300: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_SETREGION_BY_PATH_BLOCKRANGE.
   ;
   ;  *   Error 310: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_FILE_TO_GRIDLIST.
   ;
   ;  *   Error 320: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_FILE_GRID_TO_FIELDLIST.
   ;
   ;  *   Error 330: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_READDATA.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
   ;
   ;  *   chk_misr_block.pro
   ;
   ;  *   is_readable.pro
   ;
   ;  *   orbit2date.pro
   ;
   ;  *   today.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS: None.
   ;
   ;  EXAMPLES:
   ;
   ;      [Insert the command and its outcome]
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2018–08–14: Version 0.9 — Initial release.
   ;
   ;  *   2018–08–15: Version 1.0 — Initial public release.
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

   ;  Return to the calling routine with an error message if this function is
   ;  called with an unreadable l1b2_file argument:
      rc = is_readable(l1b2_file, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 1) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
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

   ;  Get today's date:
   date = today(FMT = 'ymd')

   ;  Retrieve the MISR Mode, Path, Orbit, Camera and Version information
   ;  from the filename:
   parts = STRSPLIT(FILE_BASENAME(l1b2_file), '_', /EXTRACT)
   misr_mode = parts[4]
   misr_path = FIX(STRMID(parts[5], 1, 3))
   misr_orbit = LONG(STRMID(parts[6], 1, 6))
   misr_camera = parts[7]
   misr_version = parts[8] + '_' + STRMID(parts[9], 0, 4)

   ;  Get the date of acquisition of this MISR Orbit:
   acquis_date = orbit2date(LONG(misr_orbit), DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF (debug AND (excpt_cond NE '')) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Create the output meta_data structure:
   meta_data = CREATE_STRUCT('Title', $
      'Pixel counts for a single Block of a single MISR L1B2 GM file')
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
      error_code = 300
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': status from MTK_SETREGION_BY_PATH_BLOCKRANGE = ' + strstr(status)
      RETURN, error_code
   ENDIF

   ;  Retrieve the names of the grids:
   status = MTK_FILE_TO_GRIDLIST(l1b2_file, ngrids, grids)
   IF (debug AND (status NE 0)) THEN BEGIN
      error_code = 310
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': status from MTK_FILE_TO_GRIDLIST = ' + strstr(status)
      RETURN, error_code
   ENDIF
   meta_data = CREATE_STRUCT(meta_data, 'Ngrids', ngrids)

   ;  For each of the first 4 grids, record its name:
   FOR i = 0, ngrids - 1 DO BEGIN
      IF (i LT 4) THEN BEGIN
         tagg = 'Grid_' + strstr(i)
         valg = grids[i]
         meta_data = CREATE_STRUCT(meta_data, tagg, valg)

   ;  Retrieve the names of the fields in this grid:
         status = MTK_FILE_GRID_TO_FIELDLIST(l1b2_file, grids[i], $
            nfields, fields)
         IF (debug AND (status NE 0)) THEN BEGIN
            error_code = 320
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': status from MTK_FILE_GRID_TO_FIELDLIST = '+ strstr(status)
            RETURN, error_code
         ENDIF

         tagnf = tagg + '_Nfields'
         valnf = nfields
         meta_data = CREATE_STRUCT(meta_data, tagnf, valnf)

   ;  For each of the first 3 fields, record its name:
         FOR j = 0, nfields - 1 DO BEGIN
            IF (j LT 3) THEN BEGIN
               tagfn = tagg + '_Field_' + strstr(j)
               valfn = fields[j]
               meta_data = CREATE_STRUCT(meta_data, tagfn, valfn)

   ;  Read the data for that grid and field:
               status = MTK_READDATA(l1b2_file, grids[i], fields[j], region, $
                  databuf, mapinfo)
               IF (status NE 0) THEN BEGIN
                  error_code = 330
                  excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
                     ': status from MTK_READDATA = '+ strstr(status)
                  RETURN, error_code
               ENDIF

   ;  Count the total number of pixels in that field:
               npixels = N_ELEMENTS(databuf)
               tagnp = tagfn + '_Npixels'
               valnp = npixels
               meta_data = CREATE_STRUCT(meta_data, tagnp, valnp)

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
            ENDIF
         ENDFOR
      ENDIF
   ENDFOR

   RETURN, return_code

END
