FUNCTION plt_scatt_gen, array_1, array_1_title, array_2, array_2_title, $
   title, pob_str, misr_mode, NPTS = npts, RMSD = rmsd, $
   CORRCOEFF = corrcoeff, LIN_COEFF_A = lin_coeff_a, $
   LIN_COEFF_B = lin_coeff_b, CHISQR = chisqr, PROB = prob, $
   SET_MIN_SCATT = set_min_scatt, PREFIX = prefix, VERBOSE = verbose, $
   DEBUG = debug, EXCPT_COND = excpt_cond

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
   ;  SYNTAX:
   ;  rc = plt_scatt_gen(array_1, array_1_title, array_2, array_2_title, $
   ;  pob_str, misr_mode, NPTS = npts, RMSD = rmsd, CORRCOEFF = corrcoeff, $
   ;  LIN_COEFF_A = lin_coeff_a, LIN_COEFF_B = lin_coeff_b, CHISQR = chisqr, $
   ;  PROB = prob, SET_MIN_SCATT = set_min_scatt, PREFIX = prefix, VERBOSE = verbose, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
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
   ;  *   pob_str {STRING} [I]: A string formatted as Pxxx_Oyyyyyy_Bzzz
   ;      indicating the MISR PATH, ORBIT and BLOCK concerned.
   ;
   ;  *   misr_mode {STRING} [I]: The MISR MODE (either GM or LM).
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
   ;      Pearson correlation coefficient between the two data channels.
   ;
   ;  *   LIN_COEFF_A = lin_coeff_a {FLOAT} [I] (Default value: None): The
   ;      intercept coefficient of the linear fit equation between array_1
   ;      and array_2.
   ;
   ;  *   LIN_COEFF_B = lin_coeff_b {FLOAT} [I] (Default value: None): The
   ;      slope coefficient of the linear fit equation between array_1 and
   ;      array_2.
   ;
   ;  *   CHISQR = chisqr {FLOAT} [I] (Default value: None): The value of
   ;      the Chi square statistics associated with the linear fit
   ;      equation.
   ;
   ;  *   PROB = prob {FLOAT} [I] (Default value: None): The probability
   ;      that the computed fit would have a value of CHISQR or greater.
   ;
   ;  *   SET_MIN_SCATT = set_min_scatt {STRING} [I] (Default value: None):
   ;      The minimum value to be used on the X and Y axes of the
   ;      histograms. WARNING: This value must be provided as a STRING
   ;      because the value 0.0 is frequently desirable as the minimum for
   ;      the scatterplot, but that numerical value would be
   ;      misinterpreted as NOT setting the keyword.
   ;
   ;  *   PREFIX = prefix {INT} [I] (Default value: ’Scatt_’): Prefix to
   ;      the name of the log and scatterplot output files.
   ;
   ;  *   VERBOSE = verbose {INT} [I] (Default value: None): Flag to save
   ;      (1) or skip (0) the log file.
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
   ;  *   Error 140: The input positional parameters array_1_title is not
   ;      of type STRING.
   ;
   ;  *   Error 150: The input positional parameters array_2_title is not
   ;      of type STRING.
   ;
   ;  *   Error 160: The input positional parameters title is not of type
   ;      STRING.
   ;
   ;  *   Error 170: The input positional parameter misr_mode is invalid.
   ;
   ;  *   Error 199: Unrecognized computer: Update the function
   ;      set_root_dirs.
   ;
   ;  *   Error 200: The optional keyword parameter npts is not of type
   ;      INTEGER.
   ;
   ;  *   Error 210: The optional keyword parameter rmsd is not of type
   ;      FLOAT.
   ;
   ;  *   Error 220: The optional keyword parameter corrcoeff is not of
   ;      type FLOAT.
   ;
   ;  *   Error 230: The optional keyword parameter lin_coeff_a is not of
   ;      type FLOAT.
   ;
   ;  *   Error 240: The optional keyword parameter lin_coeff_b is not of
   ;      type FLOAT.
   ;
   ;  *   Error 250: The optional keyword parameter chisqr is not of type
   ;      FLOAT.
   ;
   ;  *   Error 260: The optional keyword parameter prob is not of type
   ;      FLOAT.
   ;
   ;  *   Error 500: An exception condition occurred in is_writable.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   chk_misr_mode.pro
   ;
   ;  *   is_array.pro
   ;
   ;  *   is_integer.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   is_string.pro
   ;
   ;  *   is_writable.pro
   ;
   ;  *   set_root_dirs.pro
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
   ;  REFERENCES: None.
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

   IF (~KEYWORD_SET(prefix)) THEN prefix = 'Scatt_'

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 7
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): array_1, array_1_title, array_2, ' + $
            'array_2_title, title, pob_str, misr_mode.'
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
            ': The input positional parameters array_1_title is not ' + $
            'of of type STRING.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'array_2_title' is not of type STRING:
      IF (is_string(array_2_title) NE 1) THEN BEGIN
         error_code = 150
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameters array_2_title is not ' + $
            'of of type STRING.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'title' is not of type STRING:
      IF (is_string(title) NE 1) THEN BEGIN
         error_code = 160
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameters title is not ' + $
            'of of type STRING.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_mode' is invalid:
      rc = chk_misr_mode(misr_mode, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 170
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the optional input
   ;  keyword parameter npts is not of a numeric type:
      IF (KEYWORD_SET(npts) AND (is_integer(npts) NE 1)) THEN BEGIN
         error_code = 200
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The optional keyword parameter npts is not of type INTEGER.'
         RETURN, error_code
      ENDIF ELSE BEGIN
         npts = LONG(npts)
      ENDELSE

   ;  Return to the calling routine with an error message if the optional input
   ;  keyword parameter rmsd is not of a numeric type:
      IF (KEYWORD_SET(rmsd) AND (is_numeric(rmsd) NE 1)) THEN BEGIN
         error_code = 210
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': The optional keyword parameter rmsd is not of type FLOAT.'
         RETURN, error_code
      ENDIF ELSE BEGIN
         rmsd = FLOAT(rmsd)
      ENDELSE

   ;  Return to the calling routine with an error message if the optional input
   ;  keyword parameter corrcoeff is not of a numeric type:
      IF (KEYWORD_SET(corrcoeff) AND (is_numeric(corrcoeff) NE 1)) THEN BEGIN
         error_code = 220
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': The optional keyword parameter corrcoeff is not of type FLOAT.'
         RETURN, error_code
      ENDIF ELSE BEGIN
         corrcoeff = FLOAT(corrcoeff)
      ENDELSE

   ;  Return to the calling routine with an error message if the optional input
   ;  keyword parameter lin_coeff_a is not of a numeric type:
      IF (KEYWORD_SET(lin_coeff_a) AND $
         (is_numeric(lin_coeff_a) NE 1)) THEN BEGIN
         error_code = 230
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': The optional keyword parameter lin_coeff_a is not of type FLOAT.'
         RETURN, error_code
      ENDIF ELSE BEGIN
         lin_coeff_a = FLOAT(lin_coeff_a)
      ENDELSE

   ;  Return to the calling routine with an error message if the optional input
   ;  keyword parameter lin_coeff_b is not of a numeric type:
      IF (KEYWORD_SET(lin_coeff_b) AND $
         (is_numeric(lin_coeff_b) NE 1)) THEN BEGIN
         error_code = 240
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': The optional keyword parameter lin_coeff_b is not of type FLOAT.'
         RETURN, error_code
      ENDIF ELSE BEGIN
         lin_coeff_b = FLOAT(lin_coeff_b)
      ENDELSE

   ;  Return to the calling routine with an error message if the optional input
   ;  keyword parameter chisqr is not of a numeric type:
      IF (KEYWORD_SET(chisqr) AND (is_numeric(chisqr) NE 1)) THEN BEGIN
         error_code = 250
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': The optional keyword parameter chisqr is not of type FLOAT.'
         RETURN, error_code
      ENDIF ELSE BEGIN
         chisqr = FLOAT(chisqr)
      ENDELSE

   ;  Return to the calling routine with an error message if the optional input
   ;  keyword parameter prob is not of a numeric type:
      IF (KEYWORD_SET(prob) AND (is_numeric(prob) NE 1)) THEN BEGIN
         error_code = 260
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The optional keyword parameter prob is not of type FLOAT.'
         RETURN, error_code
      ENDIF ELSE BEGIN
         prob = FLOAT(prob)
      ENDELSE

   ;  Return to the calling routine with an error message if the optional input
   ;  keyword parameter set_min_scatt is not a STRING (this is required because
   ;  the value 0.0 is frequently desirable as the minimum for the scatterplot,
   ;  but that numerical value would be interpreted as NOT setting the keyword):
      IF (KEYWORD_SET(set_min_scatt) AND $
         (is_numstring(strstr(set_min_scatt)) NE 1)) THEN BEGIN
         error_code = 270
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The optional keyword parameter set_min_scatt is not ' + $
            'provided as a numeric STRING value.'
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
      min_range_1 = set_min_scatt
      min_range_2 = set_min_scatt
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
      TITLE = title)

   ;  Add annotations if they are provided:
   fmt1 = '(F8.3)'
   fmt2 = '(F6.3)'
   IF (KEYWORD_SET(npts)) THEN BEGIN
      my_num = TEXT(min_range_1 + 0.05 * (max_range_1 - min_range_1), $
         min_range_2 + 0.85 * (max_range_2 - min_range_2), $
         /DATA, 'n_pts = ' + strstr(npts), $
         FONT_SIZE = 9)
   ENDIF
   IF (KEYWORD_SET(chisqr)) THEN BEGIN
      chi2_str = STRTRIM(STRING(round_dec(chisqr, 3), $
         FORMAT = fmt1), 2)
      my_chi2 = TEXT(min_range_1 + 0.05 * (max_range_1 - min_range_1), $
         min_range_2 + 0.90 * (max_range_2 - min_range_2), $
         /DATA, '$\chi^2 = $' + $
         chi2_str, FONT_SIZE = 9)
   ENDIF
   IF (KEYWORD_SET(rmsd)) THEN BEGIN
      rmsd_str = STRTRIM(STRING(round_dec(rmsd, 3), $
         FORMAT = fmt2), 2)
      my_rmsd = TEXT(min_range_1 + 0.95 * (max_range_1 - min_range_1), $
         min_range_2 + 0.10 * (max_range_2 - min_range_2), $
         /DATA, 'RMSD = ' + rmsd_str, ALIGNMENT = 1.0, FONT_SIZE = 9)
   ENDIF
   IF (KEYWORD_SET(corrcoeff)) THEN BEGIN
      pear_str = STRTRIM(STRING(round_dec(corrcoeff, 3), $
         FORMAT = fmt2), 2)
      my_cc = TEXT(min_range_1 + 0.95 * (max_range_1 - min_range_1), $
         min_range_2 + 0.05 * (max_range_2 - min_range_2), $
         /DATA, 'Pearson Corr. Coeff. = ' + $
         pear_str, ALIGNMENT = 1.0, FONT_SIZE = 9)
   ENDIF

   ;  Overplot the linear fit, if the coefficients are provided:
   IF (KEYWORD_SET(lin_coeff_a) AND KEYWORD_SET(lin_coeff_b)) THEN BEGIN
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

   ;  Return to the calling routine with an error message if the output
   ;  directory 'fff_fpath' is not writable, and create it if it does not
   ;  exist:
   plot_fpath = root_dirs[3] + pob_str + '/L1B2_' + misr_mode + '/'
   rc = is_writable(plot_fpath, DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND ((rc EQ 0) OR (rc EQ -1))) THEN BEGIN
      error_code = 500
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF
   IF (rc EQ -2) THEN FILE_MKDIR, plot_fpath

   fnt = array_2_title.Replace(' ', '_')
   plot_fname = prefix + fnt + '.png'
   plot_fspec = plot_fpath + plot_fname
   my_scat.Save, plot_fspec, BORDER = 20, RESOLUTION = 300
   my_scat.Close

   IF (KEYWORD_SET(verbose)) THEN BEGIN
      PRINT, 'The scatterplot has been saved in ' + plot_fspec
   ENDIF

   RETURN, return_code

END
