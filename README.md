This archive contains the data and source code for the following paper:

* J. Urbano and M. Marrero, "[How do Gain and Discount Functions Affect the Correlation between DCG and User Satisfaction?](http://julian-urbano.info/files/publications/062-how-gain-discount-functions-affect-correlation-system-effectiveness-user-satisfaction.pdf)", *European Conference on Information Retrieval*, 2015.

A [single ZIP file](https://github.com/julian-urbano/ecir2015-dcg/archive/master.zip) can be downloaded as well.

## Project Structure

* `bin/` Shell scripts to run the code in Linux or Windows.
* `config/` Machine-dependent configuration files.
* `data/` Input data files.
* `output/` Generated output files.
* `src/` Source code to run.
* `template/` HTML task template (live version available [here](http://julian-urbano.github.io/ecir2015-dcg/template/)).

## How to run

1. Edit the `config/paths.sh` file and make the variables point to the correct paths in your machine.
2. Run the `bin/all.sh` script from the base directory. Alternatively, you can run each script in `bin/` individually, as long as you follow the order.

If you are on a Windows machine, just use the `.bat` files instead of the `.sh` files.

## Details

### Input
 
* `data/crowd.csv` contains all answers accepted by Crowdflower. Some of the columns are (`<N>` goes from 1 to 5):
  * `query` ID of the query clip.
  * `d<N><X>` ID of the `<N>`-th document retrieved by service `<X>`.
  * `DCG<G><D><X>` DCG score by service `<X>`, with `<G>` gain and `<D>` discount.
    * Gain codes are: `b2` (Bin(2)), `b1` (Bin(1)), `e5` (Exp(5)), `e3` (Exp(3)), `e2` (Exp(2)), `l` (Linear).
    * Discount codes are: `z` (Zipfian), `l` (Linear), `l2` (Log(2)), `l3` (Log(3)), `l5` (Log(5)), `n` (Constant).

### Output

* `output/anova.txt` ANOVA tables from Section 4 of the paper.
* `output/biases.csv` bias scores from Section 4 of the paper.
* `output/fig<X>/` PDF files for Figure `<X>` in the paper.

### Code

* `src/01-mappings.R` makes plots for Figures 1 and 2, and computes bias scores.
* `src/02-boxplots.R` runs ANOVA and makes plots for Figure 3.

## License

 * Databases and their contents are distributed under the terms of the [Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/).
 * Software is distributed under the terms of the [GNU General Public License v3](http://www.gnu.org/licenses/gpl-3.0-standalone.html).

When using this archive, please [cite](CITE.bib) the above paper:

    @inproceedings{Urbano2015:dcg,
      author = {Urbano, Juli\'{a}n and Marrero, M\'{o}nica},
      booktitle = {{European Conference on Information Retrieval}},
      pages = {197--202},
      title = {{How do Gain and Discount Functions Affect the Correlation between DCG and User Satisfaction?}},
      year = {2015}
    }

The MP3 player used in the template is redistributed from [here](http://flash-mp3-player.net/players/).
