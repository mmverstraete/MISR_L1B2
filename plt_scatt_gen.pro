FUNCTION plt_scatt_gen, $
   array_1, $
   array_1_title, $
   array_2, $
   array_2_title, $
   title, $
   mpob_str, $
   mpobcb_str, $
   NPTS = npts, $
   RMSD = rmsd, $
   CORRCOEFF = corrcoeff, $
   LIN_COEFF_A = lin_coeff_a, $
   LIN_COEFF_B = lin_coeff_b, $
   CHISQR = chisqr, $
   PROB = prob, $
   SET_MIN_SCATT = set_min_scatt, $
   SET_MAX_SCATT = set_max_scatt, $
   SCATT_PATH = scatt_path, $
   PREFIX = prefix, $
   VERBOSE = verbose, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function plots the scatter diagram of a pair of MISR
   ;  L1B2 channels (against each other), optionally with information
   ;  about their statistical relation. The input positional parameter
   ;  array_1 refers to the independent variable (X axis), while the input
   ;  positional parameter array_2 designates the dependent variable (Y
   ;  axis).
   ;
   ;  ALGORITHM: This function relies on the IDL functions SCATTERPLOT and
   ;  PLOT to generate the required exhibit; the optional statistical
   ;  information is provided through input keyword parameters.
   ;
   ;  SYNTAX: rc = plt_scatt_gen(array_1, array_1_title, $
   ;  array_2, array_2_title, CORRCOEFF = corrcoeff, $
   ;  mpob_str, mpobcb_str, NPTS = npts, RMSD = rmsd, $
   ;  LIN_COEFF_A = lin_coeff_a, LIN_COEFF_B = lin_coeff_b, $
   ;  CHISQR = chisqr, PROB = prob, SET_MIN_SCATT = set_min_scatt, $
   ;  SET_MAX_SCATT = set_max_scatt, PREFIX = prefix, $
   ;  VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   array_1 {FLOAT} [I]: The values of the source (x) MISR data
   ;      channel.
   ;
   ;  *   array_1_title {STRING} [I]: The label of the (x) axis.
   ;
   ;  *   array_2 {FLOAT} [I]: The values of the target (y) MISR data
   ;      channel.
   ;
   ;  *   array_2_title {STRING} [I]: The label of the (y) axis.
   ;
   ;  *   title {STRING} [I]: The title of the scatterplot figure.
   ;
   ;  *   mpob_str {STRING} [I]: A string formatted as
   ;      mM-Pxxx-Oyyyyyy-Bzzz, indicating the MISR MODE, PATH, ORBIT and
   ;      BLOCK concerned.
   ;
   ;  *   mpobcb_str {STRING} [I]: A string formatted as
   ;      mM-Pxxx-Oyyyyyy-Bzzz-[cam]-[bnd], indicating the target MISR
   ;      MODE, PATH, ORBIT, BLOCK, CAMERA and BAND.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   NPTS = npts {LONG} [I] (Default value: None): The number of data
   ;      points used to compute the statistics.
   ;
   ;  *   RMSD = rmsd {FLOAT} [I] (Default value: None): The Root Mean
   ;      Square Difference between the two data channels.
   ;
   ;  *   CORRCOEFF = corrcoeff {FLOAT} [I] (Default value: None): The
   ;      Pearson
   ;      correlation coefficient between the two data channels.
   ;
   ;  *   LIN_COEFF_A = lin_coeff_a {FLOAT} [I] (Default value: None): The
   ;      intercept coefficient of the linear fit equation between array_1
   ;      and array_2.
   ;
   ;  *   LIN_COEFF_B = lin_coeff_b {FLOAT} [I] (Default value: None): The
   ;      slope coefficient of the linear fit equation between array_1 and
   ;      array_2.
   ;
   ;  *   CHISQR = chisqr {DOUBLE} [I] (Default value: None): The value of
   ;      the Chi square statistics associated with the linear fit
   ;      equation.
   ;
   ;  *   PROB = prob {FLOAT} [I] (Default value: None): Probability that
   ;      the computed fit would have a value of CHISQR or greater.
   ;
   ;  *   SET_MIN_SCATT = set_min_scatt {STRING} [I] (Default value: None):
   ;      The minimum value to be used on the X and Y axes of the
   ;      histograms. WARNING: This value must be provided as a STRING
   ;      because the value 0.0 is frequently desirable as the minimum for
   ;      the scatterplot, but that numerical value would be
   ;      misinterpreted as NOT setting the keyword.
   ;
   ;  *   SET_MAX_SCATT = set_max_scatt {STRING} [I] (Default value: None):
   ;      The maximum value to be used on the X and Y axes of the
   ;      histograms. WARNING: By analogy with set_min_scatt, this value
   ;      must be provided as a STRING because the value 0.0 is frequently
   ;      desirable as the minimum for the scatterplot, but that numerical
   ;      value would be misinterpreted as NOT setting the keyword.
   ;
   ;  *   SCATT_PATH = scatt_path {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the output folder
   ;      containing the scatterplots.
   ;
   ;  *   PREFIX = prefix {INT} [I] (Default value: ’Scatt_’): Prefix to
   ;      the name of the log and scatterplot output files.
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
   ;      provided in the call. The scatterplot and optionally the log
   ;      file are saved in the expected folder.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The scatterplot and the log file may not exist.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: The input positional parameter array_1 is not a
   ;      numeric array.
   ;
   ;  *   Error 120: The input positional parameter array_2 is not a
   ;      numeric array.
   ;
   ;  *   Error 130: The input positional parameters array_1 and array_2
   ;      are of different sizes.
   ;
   ;  *   Error 140: The input positional parameter array_1_title is not
   ;      of type STRING.
   ;
   ;  *   Error 150: The input positional parameter array_2_title is not
   ;      of type STRING.
   ;
   ;  *   Error 160: The input positional parameter title is not of type
   ;      STRING.
   ;
   ;  *   Error 170: The input positional parameter mpob_str is not of
   ;      type STRING.
   ;
   ;  *   Error 180: The input positional parameter mpobcb_str is not of
   ;      type STRING.
   ;
   ;  *   Error 199: Unrecognized computer: Update the function
   ;      set_root_dirs.
   ;
   ;  *   Error 200: The optional keyword parameter npts is not of type
   ;      INTEGER.
   ;
   ;  *   Error 210: The optional keyword parameter rmsd is not of a
   ;      numeric type.
   ;
   ;  *   Error 220: The optional keyword parameter corrcoeff is not of a
   ;      numeric type.
   ;
   ;  *   Error 230: The optional keyword parameter lin_coeff_a is not of
   ;      a numeric type.
   ;
   ;  *   Error 240: The optional keyword parameter lin_coeff_b is not of
   ;      a numeric type.
   ;
   ;  *   Error 250: The optional keyword parameter chisqr is not of a
   ;      numeric type.
   ;
   ;  *   Error 260: The optional keyword parameter prob is not of a
   ;      numeric type.
   ;
   ;  *   Error 270: The optional keyword parameter set_min_scatt is not
   ;      provided as a numeric STRING value.
   ;
   ;  *   Error 280: The optional keyword parameter set_max_scatt is not
   ;      provided as a numeric STRING value.
   ;
   ;  *   Error 400: The output folder plot_fpath is unwritable.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   force_path_sep.pro
   ;
   ;  *   is_array.pro
   ;
   ;  *   is_integer.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   is_numstring.pro
   ;
   ;  *   is_string.pro
   ;
   ;  *   is_writable_dir.pro
   ;
   ;  *   set_root_vers.pro
   ;
   ;  *   set_value_range.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function works equally well for GM and LM files.
   ;
   ;  EXAMPLES:
   ;
   ;      [See practical example in the output of function
   ;      best_fit_l1b2.pro.]
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
   ;  VERSIONING:
   ;
   ;  *   2018–05–02: Version 0.9 — Initial release.
   ;
   ;  *   2018–05–16: Version 1.0 — Initial public release.
   ;
   ;  *   2018–05–18: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2018–08–07: Version 1.6 — Add the optional
   ;      SET_MIN_SCATT = set_min_scatt keyword parameter.
   ;
   ;  *   2018–10–13: Version 1.7 — Change the output path to match the
   ;      current organization of files.
   ;
   ;  *   2019–01–23: Version 1.8 — Add the optional
   ;      SET_MAX_SCATT = set_max_scatt keyword parameter.
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
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the use of
   ;      verbose and the assignment of numeric return codes), and switch
   ;      to 3-parts version identifiers.
   ;
   ;  *   2019–09–30: Version 2.1.1 — Update the code to include
   ;      annotations in scatterplots only when they take on finite
   ;      values.
   ;
   ;  *   2019–10–24: Version 2.1.2 — Update the code to prevent a run
   ;      time error when some of the optional keyword parameters are
   ;      undefined.
   ;
   ;  *   2020–03–30: Version 2.1.5 — Software version described in the
   ;      preprint published in _ESSDD_ referenced above.
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
   IF (~KEYWORD_SET(prefix)) THEN prefix = 'Scatt_'
   IF (KEYWORD_SET(verbose)) THEN BEGIN
      IF (is_numeric(verbose)) THEN verbose = FIX(verbose) ELSE verbose = 0
      IF (verbose LT 0) THEN verbose = 0
      IF (verbose GT 3) THEN verbose = 3
   ENDIF ELSE verbose = 0
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   ;  Control the amount of output on the console during processing:
   IF (verbose GT 1) THEN PRINT, 'Entering ' + rout_name + '.'
   IF (verbose LT 3) THEN buffer = 1 ELSE buffer = 0

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 7
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): array_1, array_1_title, array_2, ' + $
            'array_2_title, title, mpob_str, mpobcb_str.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'array_1' is not a numeric array:
      IF ((is_numeric(array_1) NE 1) OR (is_array(array_1) NE 1)) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter array_1 is not a ' + $
            'numeric array.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'array_2' is not a numeric array:
      IF ((is_numeric(array_2) NE 1) OR (is_array(array_2) NE 1)) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter array_2 is not a ' + $
            'numeric array.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameters 'array_1' and 'array_2' are of different sizes:
      IF (N_ELEMENTS(array_1) NE N_ELEMENTS(array_2)) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameters array_1 and array_2 are ' + $
            'of different sizes.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameters 'array_1_title' is not of type STRING:
      IF (is_string(array_1_title) NE 1) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter array_1_title is not ' + $
            'of type STRING.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'array_2_title' is not of type STRING:
      IF (is_string(array_2_title) NE 1) THEN BEGIN
         error_code = 150
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter array_2_title is not ' + $
            'of type STRING.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'title' is not of type STRING:
      IF (is_string(title) NE 1) THEN BEGIN
         error_code = 160
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter title is not ' + $
            'of type STRING.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'mpob_str' is not of type STRING:
      IF (is_string(mpob_str) NE 1) THEN BEGIN
         error_code = 170
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter mpob_str is not ' + $
            'of type STRING.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'mpobcb_str' is not of type STRING:
         IF (is_string(mpobcb_str) NE 1) THEN BEGIN
            error_code = 180
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': The input positional parameter mpobcb_str is not ' + $
               'of type STRING.'
            RETURN, error_code
         ENDIF

   ;  Return to the calling routine with an error message if the optional input
   ;  keyword parameter npts is not of a numeric type:
      IF (KEYWORD_SET(npts) AND (is_integer(npts) NE 1)) THEN BEGIN
         error_code = 200
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The optional keyword parameter npts is not of type INTEGER.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the optional input
   ;  keyword parameter rmsd is not of a numeric type:
      IF (KEYWORD_SET(rmsd) AND (is_numeric(rmsd) NE 1)) THEN BEGIN
         error_code = 210
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': The optional keyword parameter rmsd is not of a numeric type.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the optional input
   ;  keyword parameter corrcoeff is not of a numeric type:
      IF (KEYWORD_SET(corrcoeff) AND (is_numeric(corrcoeff) NE 1)) THEN BEGIN
         error_code = 220
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': The optional keyword parameter corrcoeff is not of a numeric type.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the optional input
   ;  keyword parameter lin_coeff_a is not of a numeric type:
      IF (KEYWORD_SET(lin_coeff_a) AND $
         (is_numeric(lin_coeff_a) NE 1)) THEN BEGIN
         error_code = 230
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': The optional keyword parameter lin_coeff_a is not of a ' + $
         'numeric type.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the optional input
   ;  keyword parameter lin_coeff_b is not of a numeric type:
      IF (KEYWORD_SET(lin_coeff_b) AND $
         (is_numeric(lin_coeff_b) NE 1)) THEN BEGIN
         error_code = 240
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': The optional keyword parameter lin_coeff_b is not of a ' + $
         'numeric type.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the optional input
   ;  keyword parameter chisqr is not of a numeric type:
      IF (KEYWORD_SET(chisqr) AND (is_numeric(chisqr) NE 1)) THEN BEGIN
         error_code = 250
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': The optional keyword parameter chisqr is not of a ' + $
         'numeric type.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the optional input
   ;  keyword parameter prob is not of a numeric type:
      IF (KEYWORD_SET(prob) AND (is_numeric(prob) NE 1)) THEN BEGIN
         error_code = 260
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The optional keyword parameter prob is not of a ' + $
            'numeric type.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the optional input
   ;  keyword parameter set_min_scatt is not a STRING (this is required because
   ;  the value 0.0 is frequently desirable as the minimum for the scatterplot,
   ;  but that numerical value would be interpreted as NOT setting the keyword):
      IF (KEYWORD_SET(set_min_scatt) AND $
         (is_numstring(set_min_scatt) NE 1)) THEN BEGIN
         error_code = 270
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The optional keyword parameter set_min_scatt is not ' + $
            'provided as a numeric STRING value.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the optional input
   ;  keyword parameter set_max_scatt is not a STRING (this is required because
   ;  the value 0.0 is frequently desirable as the minimum for the scatterplot,
   ;  but that numerical value would be interpreted as NOT setting the keyword):
      IF (KEYWORD_SET(set_max_scatt) AND $
         (is_numstring(set_max_scatt) NE 1)) THEN BEGIN
         error_code = 280
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The optional keyword parameter set_max_scatt is not ' + $
            'provided as a numeric STRING value.'
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

   ;  Set the plotting ranges of values to plot along the X and Y axes:
   min_array_1 = MIN(array_1, MAX = max_array_1)
   res = set_value_range(min_array_1, max_array_1, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   min_range_1 = res[0]
   max_range_1 = res[1]

   min_array_2 = MIN(array_2, MAX = max_array_2)
   res = set_value_range(min_array_2, max_array_2, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   min_range_2 = res[0]
   max_range_2 = res[1]

   ;  Reset the minima of the plotting ranges for the X and Y axes if a value
   ;  has been provided through the optional parameter SET_MIN_SCATT:
   IF (KEYWORD_SET(set_min_scatt)) THEN BEGIN
      min_range_1 = FLOAT(set_min_scatt)
      min_range_2 = FLOAT(set_min_scatt)
   ENDIF

   ;  Reset the maxima of the plotting ranges for the X and Y axes if a value
   ;  has been provided through the optional parameter SET_MAX_SCATT:
   IF (KEYWORD_SET(set_max_scatt)) THEN BEGIN
      max_range_1 = FLOAT(set_max_scatt)
      max_range_2 = FLOAT(set_max_scatt)
   ENDIF

   ;  Generate the scatterplot:
   my_scat = SCATTERPLOT(array_1, $
      array_2, $
      SYMBOL = 'dot', $
      DIMENSIONS = [600, 600], $
      XRANGE = [min_range_1, max_range_1], $
      YRANGE = [min_range_2, max_range_2], $
      XSTYLE = 1, $
      YSTYLE = 1, $
      XTITLE = array_1_title, $
      YTITLE = array_2_title, $
      TITLE = title, $
      BUFFER = buffer)

   ;  Add annotations if they are provided:
   fmt1 = '(F14.3)'
   fmt2 = '(F6.3)'
   IF (KEYWORD_SET(npts)) THEN BEGIN
      npts = LONG(npts)
      my_num = TEXT(min_range_1 + 0.05 * (max_range_1 - min_range_1), $
         min_range_2 + 0.85 * (max_range_2 - min_range_2), $
         /DATA, 'n_pts = ' + strstr(npts), $
         FONT_SIZE = 9)
   ENDIF
   IF (KEYWORD_SET(chisqr)) THEN BEGIN
      IF (FINITE(chisqr)) THEN BEGIN
         chi2_str = STRTRIM(STRING(round_dec(chisqr, 3), $
            FORMAT = fmt1), 2)
         my_chi2 = TEXT(min_range_1 + 0.05 * (max_range_1 - min_range_1), $
            min_range_2 + 0.90 * (max_range_2 - min_range_2), $
            /DATA, '$\chi^2 = $' + $
            chi2_str, FONT_SIZE = 9)
      ENDIF
   ENDIF
   IF (KEYWORD_SET(rmsd)) THEN BEGIN
      IF (FINITE(rmsd)) THEN BEGIN
         rmsd_str = STRTRIM(STRING(round_dec(rmsd, 3), $
            FORMAT = fmt2), 2)
         my_rmsd = TEXT(min_range_1 + 0.95 * (max_range_1 - min_range_1), $
            min_range_2 + 0.10 * (max_range_2 - min_range_2), $
            /DATA, 'RMSD = ' + rmsd_str, ALIGNMENT = 1.0, FONT_SIZE = 9)
      ENDIF
   ENDIF
   IF (KEYWORD_SET(corrcoeff)) THEN BEGIN
      IF (FINITE(corrcoeff)) THEN BEGIN
         corrcoeff = FLOAT(corrcoeff)
         pear_str = STRTRIM(STRING(round_dec(corrcoeff, 3), $
            FORMAT = fmt2), 2)
         my_cc = TEXT(min_range_1 + 0.95 * (max_range_1 - min_range_1), $
            min_range_2 + 0.05 * (max_range_2 - min_range_2), $
            /DATA, 'Pearson Corr. Coeff. = ' + $
            pear_str, ALIGNMENT = 1.0, FONT_SIZE = 9)
      ENDIF
   ENDIF

   ;  Overplot the linear fit, if the coefficients are provided:
   IF (KEYWORD_SET(lin_coeff_a) AND KEYWORD_SET(lin_coeff_b)) THEN BEGIN
      lin_coeff_a = FLOAT(lin_coeff_a)
      lin_coeff_b = FLOAT(lin_coeff_b)
      my_x = [min_range_1, max_range_1]
      my_y = lin_coeff_a + lin_coeff_b * my_x
      my_eq = 'y = ' + strstr(lin_coeff_a) + ' + ' + $
         strstr(lin_coeff_b) + ' * x'
      my_fit = PLOT(my_x, $
         my_y, $
         /OVERPLOT, $
         COLOR = 'blue', $
         THICK = 1, $
         LINESTYLE = 1, $
         XRANGE = [min_range_1, max_range_1], $
         YRANGE = [min_range_2, max_range_2])
      my_eqlbl = TEXT(min_range_1 + 0.05 * (max_range_1 - min_range_1), $
         min_range_2 + 0.95 * (max_range_2 - min_range_2), $
         /DATA, my_eq, FONT_COLOR = 'blue', $
         FONT_SIZE = 9, FONT_STYLE = 'italic')
   ENDIF

   ;  Set the directory address of the folder containing the output
   ;  scatterplot files:
   pob_str = STRMID(mpob_str, 3)
   IF (KEYWORD_SET(scatt_path)) THEN BEGIN
      rc = force_path_sep(scatt_path, DEBUG = debug, $
         EXCPT_COND = excpt_cond)
      plot_fpath = scatt_path
   ENDIF ELSE BEGIN
      plot_fpath = root_dirs[3] + pob_str + PATH_SEP() + 'BestFits' + PATH_SEP()
   ENDELSE

   ;  Check that the output directory 'plot_fpath' exists and is writable, and
   ;  if not, create it:
   res = is_writable_dir(plot_fpath, /CREATE)
   IF (debug AND (res NE 1)) THEN BEGIN
      error_code = 400
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
         rout_name + ': The directory plot_fpath is unwritable.'
      RETURN, error_code
   ENDIF

   plot_fname = prefix + mpobcb_str + '.png'
   plot_fspec = plot_fpath + plot_fname
   my_scat.Save, plot_fspec, BORDER = 20, RESOLUTION = 300
   my_scat.Close

   IF (verbose GT 0) THEN BEGIN
      PRINT, 'The scatterplot has been saved in ' + plot_fspec
   ENDIF
   IF (verbose GT 1) THEN PRINT, 'Exiting ' + rout_name + '.'

   RETURN, return_code

END
