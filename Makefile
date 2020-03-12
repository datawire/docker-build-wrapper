default: go.mod
.PHONY: default

go.mod: go.mod.gen
	./$< > $@

.DELETE_ON_ERROR:
