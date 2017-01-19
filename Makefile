TARGET ?= amd64
ARCHS ?= amd64 armhf
BASE_ARCH ?= amd64
HOMIE_DASHBOARD_VERSION ?= latest

build: tmp-$(TARGET)/Dockerfile
	docker build --build-arg ARG_ARCH=$(TARGET) --build-arg ARG_HOMIE_DASHBOARD_VERSION=$(HOMIE_DASHBOARD_VERSION) --no-cache -t homiedashboard/homie-dashboard:$(TARGET)-latest tmp-$(TARGET)

tmp-$(TARGET)/Dockerfile: Dockerfile $(shell find overlay-common overlay-$(TARGET))
	rm -rf tmp-$(TARGET)
	mkdir tmp-$(TARGET)
	cp Dockerfile $@
	cp -rf overlay-common tmp-$(TARGET)/
	cp -rf overlay-$(TARGET) tmp-$(TARGET)/
	for arch in $(ARCHS); do                     \
	  if [ "$$arch" != "$(TARGET)" ]; then       \
	    sed -i "/arch=$$arch/d" $@;              \
	  fi;                                        \
	done
	sed -i '/#[[:space:]]*arch=$(TARGET)/s/^#//' $@
	sed -i 's/#[[:space:]]*arch=$(TARGET)//g' $@
	cat $@
