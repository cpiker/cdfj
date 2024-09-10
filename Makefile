# Installation Location ###################################################### #

ifeq ($(PREFIX),)
ifeq ($(HOME),)
PREFIX=$(USERPROFILE)
else
PREFIX=$(HOME)
endif
endif

ifeq ($(JAVA_HOME),)
$(error set JAVA_HOME first, ex: JAVA_HOME=/usr/lib/jvm/java-11-openjdk)
endif

ifeq ($(H_ARCH),)
JAVAVER:=$(shell $(JAVA_HOME)/bin/javac platver.java && $(JAVA_HOME)/bin/java -cp . platver 2>/dev/null)
ifeq ($(JAVAVER),)
$(error Couldn't determine your java platform version)
endif
H_ARCH=java$(JAVAVER)
endif

ifeq ($(INST_HOST_LIB),)
INST_HOST_LIB=$(PREFIX)/lib/$(H_ARCH)
endif

# Library information ######################################################## #

VERSION:=3.8.2
M2DIR:=$(HOME)/.m2/repository/gov/nasa/gsfc/cdf/cdfj/$(VERSION)
LIB_JAR:=cdfj-$(VERSION).jar

# Build/Install rules ######################################################## #

build:$(M2DIR)/$(LIB_JAR)

$(M2DIR)/$(LIB_JAR):
	./mvnw clean install
	
install:$(INST_HOST_LIB)/$(LIB_JAR)

$(INST_HOST_LIB)/$(LIB_JAR):$(M2DIR)/$(LIB_JAR)
	install -D -m 0664 $< $@
	
clean:
	rm -r $(M2DIR)
	
distclean:
	rm -r $(M2DIR)
	
	
