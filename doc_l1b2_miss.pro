PRO doc_l1b2_miss, inspect, VERBOSE = verbose, $
   DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This program inspects a series of MISR L1B2 files, in
   ;  either Global or Local Mode, for specified PATHS, ORBITS and BLOCKS,
   ;  to assess the prevalence of missing pixels and pixels with an RDQI
   ;  of 2.
   ;
   ;  ALGORITHM: This program reads a plain text input file inspect
   ;  defining the set of MISR L1B2 MODES, PATHS, ORBITS and BLOCKS to
   ;  inspect, then searches the designated data from all available
   ;  cameras and bands for missing values (UINT value 65523) or pixels
   ;  with an RDQI of 2, compiles statistics on the prevalence of those 2
   ;  types of pixels in that set, and saves the results into a plain text
   ;  file, in the same directory as the input file, with the same
   ;  basename and the suffix _out and the extension .txt.
   ;
   ;  SYNTAX:
   ;  doc_l1b2_miss, inspect, DEBUG = debug, EXCPT_COND = excpt_cond
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   inspect {STRING} [I]: The full name (path, name and .txt
   ;      extension) of a plain text file, which can be located anywhere
   ;      on the disk system accessible to this computer, and defining the
   ;      set of MISR L1B2 files to inspect. Each line in that file
   ;      contains a statement of work encapsulated in 4 strings,
   ;      separated by commas:
   ;
   ;      -   the MODE, or ranges of MODES
   ;
   ;      -   the PATH, or ranges of PATHS
   ;
   ;      -   the ORBIT, or ranges of ORBITS
   ;
   ;      -   the BLOCK, or ranges of BLOCKS
   ;
   ;      where
   ;
   ;      -   MODE is either [GM], or [LM],
   ;
   ;      -   PATH is formatted as Pxxx, where xxx is a valid MISR PATH
   ;          number,
   ;
   ;      -   ORBIT is formatted as Oyyyyyy, where yyyyyy is a valid MISR
   ;          ORBIT number,
   ;
   ;      -   BLOCK is formatted as Bzzz, where zzz is a valid MISR BLOCK
   ;          number, and
   ;
   ;      -   ‘ranges’ are coded as [item1]-[item2], where all items from
   ;          [item1] to [item2] inclusive are to be inspected.
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
   ;  RETURNED VALUE TYPE: N/A.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns [0, or default returned value], and the output keyword
   ;      parameter excpt_cond is set to a null string, if the optional
   ;      input keyword parameter DEBUG is set and if the optional output
   ;      keyword parameter EXCPT_COND is provided in the call. [Optional,
   ;      if appropriate:] The output positional parameter(s) [and output
   ;      file(s)] contain(s) the results generated by this function.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns [a non-zero error code, or some non-sandard returned
   ;      value], and the output keyword parameter excpt_cond contains a
   ;      message about the exception condition encountered, if the
   ;      optional input keyword parameter DEBUG is set and if the
   ;      optional output keyword parameter EXCPT_COND is provided.
   ;      [Optional, if appropriate:] Output positional parameters [and
   ;      output files] may be undefined, inexistent, incomplete or
   ;      useless.
   ;
   ;      For programs:
   ;
   ;  *   If no exception condition has been detected, the keyword
   ;      parameter excpt_cond is set to a null string, if the optional
   ;      input keyword parameter DEBUG was set and if the optional output
   ;      keyword parameter EXCPT_COND was provided in the call.
   ;      [Optional, if appropriate:] The output positional parameter(s)
   ;      [and output file(s)] contain(s) the results generated by this
   ;      program.
   ;
   ;  *   If an exception condition has been detected, the optional output
   ;      keyword parameter excpt_cond contains a message about the
   ;      exception condition encountered, if the optional input keyword
   ;      parameter DEBUG is set and if the optional output keyword
   ;      parameter EXCPT_COND is provided. [Optional, if appropriate:]
   ;      Output positional parameters [and output files] may be
   ;      undefined, inexistent, incomplete or useless.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter xxx is not of type yyy.
   ;
   ;  *   Error 200: An exception condition occurred in routine.pro.
   ;
   ;  *   Error 300: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_SETREGION_BY_PATH_BLOCKRANGE.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function...
   ;
   ;  EXAMPLES:
   ;
   ;      [Insert the command and its outcome]
   ;
   ;  REFERENCES:
   ;
   ;  *   -   Paper and DOI
   ;
   ;  VERSIONING:
   ;
   ;  *   2016–06–13: Version 0.9 — Initial release.
   ;
   ;  *   2017–11–10: Version 1.0 — Initial public release.
   ;
   ;  *   2018–01–30: Version 1.1 — Implement optional debugging.
   ;
   ;  *   2018–06–01: Version 1.5 — Implement new coding standards.
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

   ;  Initialize the exception condition message:
   excpt_cond = ''

   ;  Set the default values of essential input keyword parameters:
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 1
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): inspect.'
         PRINT, error_code
         STOP
      ENDIF

   ;  Stop the program if the input positional parameter points to an
   ;  unreadable file:
      rc = is_readable(inspect, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 1) THEN BEGIN
         error_code = 400
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         PRINT, error_code
         STOP
      ENDIF
   ENDIF

   ;  Set the MISR specifications:
   misr_specs = set_misr_specs()

   ;  Identify the current operating system and computer name:
   rc = get_host_info(os_name, comp_name)

   ;  Set the standard locations for MISR and MISR-HR files on this computer:
   root_dirs = set_root_dirs()

   ;  Get today's date:
   date = today(FMT = 'ymd')

   ;  Get today's date and time:
   date_time = today(FMT = 'nice')

   ;  Retrieve the directory and basename of the input file:
   out_dir = FILE_DIRNAME(inspect, /MARK_DIRECTORY)
   basename = FILE_BASENAME(inspect, '.txt')

   ;  Open the input file:
   OPENR, in_file, inspect, /GET_LUN
   line = ''

   ; Generate the name of the output file:
   inspect_out = out_dir + basename + '_out.txt'

   ;  Stop the program if the output file is unwritable:
   rc = is_writable(inspect_out, DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (rc EQ 0) THEN BEGIN
      error_code = 500
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      PRINT, error_code
      STOP
   ENDIF

   ;  Open the output file:
   OPENW, out_file, inspect_out, /GET_LUN

   ;  Start recording outcomes:
   fmt1 = '(A30, A)'
   PRINTF, out_file, "File name: ", "'" + $
      FILE_BASENAME(inspect_out) + "'", FORMAT = fmt1
   PRINTF, out_file, "Folder name: ", "'" + $
      FILE_DIRNAME(inspect_out, /MARK_DIRECTORY) + "'", FORMAT = fmt1
   PRINTF, out_file, 'Generated by: ', rout_name, FORMAT = fmt1
   PRINTF, out_file, 'Generated on: ', comp_name, FORMAT = fmt1
   PRINTF, out_file, 'Saved on: ', date_time, FORMAT = fmt1
   PRINTF, out_file

   ;  Create the output structure:
   inspect_data = CREATE_STRUCT('Title', $
      'Prevalence statistics about missing and poor data in MISR L1B2 files.')
   tagproc = 'Generated by'
   valproc = 'doc_l1b2_miss'
   inspect_data = CREATE_STRUCT(inspect_data, tagproc, valproc)
   tagdate = 'Generated on'
   valdate = date
   inspect_data = CREATE_STRUCT(inspect_data, tagdate, valdate)

   ;  Loop over the input file lines:
   line_num = 0
   WHILE ~EOF(in_file) DO BEGIN

   ;  Record the current line:
      tagln = 'Line_' + strstr(line_num)
      valln = line_num
      inspect_data = CREATE_STRUCT(inspect_data, tagln, valln)

   ;  Read the next line in the input file:
      READF, in_file, line
      IF (verbose) THEN PRINT, 'Processing line ' + $
         strstr(line_num) + ': >' + line + '<'
      parts = STRSPLIT(line, ',', COUNT = nparts, /EXTRACT)
      IF (nparts NE 5) THEN BEGIN
         PRINTF, out_file, 'Skipping line ' + strstr(line_num) + ' (Err 4)'
         CONTINUE
      ENDIF

   ;  Parse this line and check the validity of its elements:
      misr_mode = strstr(parts[0])
      misr_path = FIX(strstr(parts[1]))
      misr_orbit = LONG(strstr(parts[2]))
      misr_block = FIX(strstr(parts[3]))
      misr_version = strstr(parts[4])

      IF (chk_misr_mode(misr_mode, $
         DEBUG = debug, EXCPT_COND = excpt_cond) NE 0) THEN BEGIN
         PRINTF, out_file, 'Skipping line ' + strstr(line_num) + ' (Err 0)'
         CONTINUE
      ENDIF
      IF (chk_misr_path(misr_path, $
         DEBUG = debug, EXCPT_COND = excpt_cond) NE 0) THEN BEGIN
         PRINTF, out_file, 'Skipping line ' + strstr(line_num) + ' (Err 1)'
         CONTINUE
      ENDIF
      IF (chk_misr_orbit(misr_orbit, $
         DEBUG = debug, EXCPT_COND = excpt_cond) NE 0) THEN BEGIN
         PRINTF, out_file, 'Skipping line ' + strstr(line_num) + ' (Err 2)'
         CONTINUE
      ENDIF
      IF (chk_misr_block(misr_block, $
         DEBUG = debug, EXCPT_COND = excpt_cond) NE 0) THEN BEGIN
         PRINTF, out_file, 'Skipping line ' + strstr(line_num) + ' (Err 3)'
         CONTINUE
      ENDIF

   ;  Generate the string version of the MISR Path number:
      rc = path2str(misr_path, misr_path_str, DEBUG = debug, $
         EXCPT_COND = excpt_cond)
      IF ((debug) AND (rc NE 0)) THEN BEGIN
         error_code = 200
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         PRINTF, out_file, 'Skipping line ' + strstr(line_num) + ' (Err 10)'
         CONTINUE
      ENDIF

   ;  Generate the string version of the MISR Orbit number:
      rc = orbit2str(misr_orbit, misr_orbit_str, DEBUG = debug, $
         EXCPT_COND = excpt_cond)
      IF ((debug) AND (rc NE 0)) THEN BEGIN
         error_code = 210
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         PRINTF, out_file, 'Skipping line ' + strstr(line_num) + ' (Err 11)'
         CONTINUE
      ENDIF

   ;  Generate the string version of the MISR Block number:
      rc = block2str(misr_block, misr_block_str, DEBUG = debug, $
         EXCPT_COND = excpt_cond)
      IF ((debug) AND (rc NE 0)) THEN BEGIN
         error_code = 220
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         PRINTF, out_file, 'Skipping line ' + strstr(line_num) + ' (Err 12)'
         CONTINUE
      ENDIF

   ;  Record the metadata in the output structure:
      tagmo = tagln + '_' + misr_mode
      valmo = misr_mode
      inspect_data = CREATE_STRUCT(inspect_data, tagmo, valmo)
      tagpa = tagln + '_' + misr_path_str
      valpa = misr_path
      inspect_data = CREATE_STRUCT(inspect_data, tagpa, valpa)
      tagor = tagln + '_' + misr_orbit_str
      valor = misr_orbit
      inspect_data = CREATE_STRUCT(inspect_data, tagor, valor)
      tagbk = tagln + '_' + misr_block_str
      valbk = misr_block
      inspect_data = CREATE_STRUCT(inspect_data, tagbk, valbk)
      tagvr = tagln + '_' + misr_version
      valvr = misr_version
      inspect_data = CREATE_STRUCT(inspect_data, tagvr, valvr)

   ;  Define the (1-Block) region of interest to the specified Block:
      status = MTK_SETREGION_BY_PATH_BLOCKRANGE(misr_path, $
         misr_block, misr_block, region)
      IF ((debug) AND (status NE 0)) THEN BEGIN
         error_code = 300
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': status from MTK_SETREGION_BY_PATH_BLOCKRANGE = ' + strstr(status)
         PRINT, error_code
         STOP
      ENDIF

   ;  Loop over the 9 cameras:
      ncams = misr_specs.NCameras
      cams = misr_specs.CameraNames
      FOR i = 0, ncams - 1 DO BEGIN
         misr_camera = cams[i]
         IF (verbose) THEN PRINT, '   Processing Camera ' + misr_camera

   ;  Generate the names of the files corresponding to the specified MISR Mode,
   ;  Path and Orbit:
         rc = mpocv2fn_l1b2(misr_mode, misr_path, misr_orbit, $
            misr_camera, misr_version, l1b2_fspec, $
            DEBUG = debug, EXCPT_COND = excpt_cond)

   ;  Skip this file if it is not found or not readable:
         rc = is_readable(l1b2_fspec, DEBUG = debug, EXCPT_COND = excpt_cond)
         IF (rc NE 1) THEN BEGIN
            PRINTF, out_file, ' File ' + l1b2_fspec + $
               ': Not found or unreadable'
            CONTINUE
         ENDIF ELSE BEGIN
            PRINTF, out_file, '   Found file ' + l1b2_fspec
         ENDELSE

   ;  Open the MISR L1B2 data file for this camera:
         OPENR, indat, l1b2_fspec, /GET_LUN

   ;  Retrieve the names of the grids in that L1B2 HDF file:
         status = MTK_FILE_TO_GRIDLIST(l1b2_fspec, ngrids, grids)
         IF ((debug) AND (status NE 0)) THEN BEGIN
            error_code = 310
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': status from MTK_FILE_TO_GRIDLIST = ' + strstr(status)
            PRINT, error_code
            STOP
         ENDIF
         PRINTF, out_file, '   Found ' + strstr(ngrids) + ' grids:'
         PRINTF, out_file, '   ' + strcat(grids, SEP_CHAR = ', ', $
            DEBUG = debug, EXCPT_COND = excpt_cond)

   ;  Loop over the 4 spectral bands:
         nbands = misr_specs.NBands
         bands = misr_specs.BandNames
         FOR j = 0, 3 DO BEGIN
            misr_band = bands[j]
            IF (verbose) THEN PRINT, '      Processing ' + grids[j]

            tagcamband = tagln + '_' + misr_camera + '_' + misr_band
            valcamband = misr_camera + '_' + misr_band
            inspect_data = CREATE_STRUCT(inspect_data, tagcamband, valcamband)

   ;  Retrieve the names of the fields in this grid:
            status = MTK_FILE_GRID_TO_FIELDLIST(l1b2_fspec, grids[j], $
               nfields, fields)
            IF ((debug) AND (status NE 0)) THEN BEGIN
               error_code = 320
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
                  ': status from MTK_FILE_GRID_TO_FIELDLIST = '+ strstr(status)
               PRINT, error_code
               STOP
            ENDIF
            PRINTF, out_file, '   Found ' + strstr(nfields) + ' fields:'
            PRINTF, out_file, '   ' + strcat(fields, SEP_CHAR = ', ', $
               DEBUG = debug, EXCPT_COND = excpt_cond)

   ;  Select the Radiance/RDQI field to count the missing pixels:
            my_field = bands[j] + ' Radiance/RDQI'
            IF (verbose) THEN PRINT, '         Processing ' + my_field

   ;  Read the data for that grid and field:
            status = MTK_READDATA(l1b2_fspec, grids[j], my_field, region, $
               databuf, mapinfo)
            IF (status NE 0) THEN BEGIN
               error_code = 330
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
                  ': status from MTK_READDATA = '+ strstr(status)
               PRINT, error_code
               STOP
            ENDIF

   ;  Count the total number of pixels in that field:
            npixels = N_ELEMENTS(databuf)
            tagpix = tagcamband + '_npixels'
            valpix = npixels
            inspect_data = CREATE_STRUCT(inspect_data, tagpix, valpix)

   ;  Count the number of missing pixels in that field:
            idx_miss = WHERE(databuf EQ 65523, nmiss)
            tagmiss = tagcamband + '_nmiss'
            valmiss = nmiss
            inspect_data = CREATE_STRUCT(inspect_data, tagmiss, valmiss)

   ;  Save the findings in the output file:
            PRINTF, out_file, '      Found ' + strstr(npixels) + ' pixels.'
            PRINTF, out_file, '      Found ' + strstr(nmiss) + ' missing pixels'

   ;  Select the RDQI field to count the number of pixels with RDQI = 2:
            my_field = bands[j] + ' RDQI'
            IF (verbose) THEN PRINT, '         Processing ' + my_field

   ; Read the data for that grid and field:
            status = MTK_READDATA(l1b2_fspec, grids[j], my_field, region, $
               databuf, mapinfo)
            IF (status NE 0) THEN BEGIN
               error_code = 340
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
                  ': status from MTK_READDATA = '+ strstr(status)
               PRINT, error_code
               STOP
            ENDIF

   ;  Count the total number of pixels in that field:
            npixels = N_ELEMENTS(databuf)

   ;  Count the number of poor pixels in that field:
            idx_poor = WHERE(databuf EQ 2, npoor)
            tagpoor = tagcamband + '_npoor'
            valpoor = npoor
            inspect_data = CREATE_STRUCT(inspect_data, tagpoor, valpoor)

   ;  Save the findings in the output file:
            PRINTF, out_file, '      Found ' + strstr(npixels) + ' pixels.'
            PRINTF, out_file, '      Found ' + strstr(npoor) + ' poor pixels'
         ENDFOR

   ;  Close the MISR L1B2 data file for this camera:
         CLOSE, indat
         FREE_LUN, indat
         PRINTF, out_file
      ENDFOR
      PRINTF, out_file
      line_num = line_num + 1
   ENDWHILE

   ;  Save the output structure in a .sav file:
   inspect_sav = out_dir + basename + '_out.sav'
   SAVE, inspect_data, FILENAME = inspect_sav
   PRINTF, out_file, 'File ' + FILE_BASENAME(inspect_sav) + ' created.'
   PRINTF, out_file

   CLOSE, in_file
   FREE_LUN, in_file

   CLOSE, out_file
   FREE_LUN, out_file

   HELP, inspect_data

   RETURN

END
