# Convenience targets for keeping the repository healthy.
#
# Nothing here rewrites the slide decks.  See MAINTENANCE.md for what the
# checks do and which warnings are expected.

PYTHON ?= python3

.PHONY: help check check-strict graphs

help:
	@echo "check        - run the repository checker (errors fail)"
	@echo "check-strict - run the checker, warnings fail as well"
	@echo "graphs       - regenerate the Gruff graphs (needs Ruby + ImageMagick)"

check:
	$(PYTHON) scripts/check_repo.py

check-strict:
	$(PYTHON) scripts/check_repo.py --strict

graphs:
	cd graphs/patches_per_release && bundle exec ruby patches_per_hour.rb
	cd graphs/patches_per_release && bundle exec ruby cves_per_release.rb
