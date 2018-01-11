
# TARGETS #

#/
# Runs C++ benchmarks consecutively.
#
# ## Notes
#
# -   This recipe delegates to local Makefiles which are responsible for actually compiling and running the respective benchmarks.
# -   This recipe is useful when wanting to glob for C++ benchmark files (e.g., run all C++ benchmarks for a particular package).
#
#
# @param {string} [BENCHMARKS_FILTER] - filepath pattern (e.g., `.*/math/base/special/beta/.*`)
# @param {string} [CXX_COMPILER] - C++ compiler (e.g., `g++`)
#
# @example
# make benchmark-cpp
#/
benchmark-cpp:
	$(QUIET) $(FIND_CPP_BENCHMARKS_CMD) | grep '^[\/]\|^[a-zA-Z]:[/\]' | while read -r file; do \
		echo ""; \
		echo "Running benchmark: $$file"; \
		cd `dirname $$file` && \
		$(MAKE) clean && \
		CXX_COMPILER="$(CXX)" \
		BOOST=$(DEPS_BOOST_BUILD_OUT) $(MAKE) && \
		$(MAKE) run || exit 1; \
	done

.PHONY: benchmark-cpp

#/
# Runs a specified list of C++ benchmarks consecutively.
#
# ## Notes
#
# -   This recipe delegates to local Makefiles which are responsible for actually compiling and running the respective benchmarks.
# -   This recipe is useful when wanting to run a list of C++ benchmark files generated by some other command (e.g., a list of changed C++ benchmark files obtained via `git diff`).
#
#
# @param {string} FILES - list of C++ benchmark file paths
# @param {string} [CXX_COMPILER] - C++ compiler (e.g., `g++`)
#
# @example
# make benchmark-cpp-files FILES='/foo/benchmark.cpp /bar/benchmark.cpp'
#/
benchmark-cpp-files:
	$(QUIET) for file in $(FILES); do \
		echo ""; \
		echo "Running benchmark: $$file"; \
		cd `dirname $$file` && \
		$(MAKE) clean && \
		CXX_COMPILER="$(CXX)" \
		BOOST=$(DEPS_BOOST_BUILD_OUT) $(MAKE) && \
		$(MAKE) run || exit 1; \
	done

.PHONY: benchmark-cpp-files
