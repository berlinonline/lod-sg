data/temp/void.nt: data/temp
	@echo "converting void.ttl to $@ ..."
	@rapper -i turtle void.ttl > $@

# This target creates the RDF file that serves as the input to the static site generator.
# All data should be merged in this file. This should include at least the VOID dataset
# description and the actual data.
# The target works by merging all prerequisites 
data/temp/all.nt: data/temp/void.nt
	@echo "combining $? to $@ ..."
	@riot --output N-TRIPLE $? > $@

cbds: _includes/cbds data/temp/all.nt
	@echo "computing concise bounded descriptions for all subjects in input data"
	@python bin/compute_cbds.py --base="https://berlinonline.github.io/lod-sg"

.PHONY: serve-local
serve-local: data/temp/all.nt cbds
	@echo "serving local version of static LOD site ..."
	@bundle exec jekyll serve

clean: clean-temp clean-cbds

clean-temp:
	@echo "deleting temp folder ..."
	@rm -rf data/temp

data/temp:
	@echo "creating temp directory ..."
	@mkdir -p data/temp

_includes/cbds:
	@echo "creating $@ directory ..."
	@mkdir -p $@

clean-cbds:
	@echo "deleting cbd folder ..."
	@rm -rf _includes/cbds
