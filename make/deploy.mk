#
# DEPLOY.MK --devkit/deploy targets.
#
# Contents:
#
# Remarks:
# The deploy targets are useful for development in the absence of a
# packaging system.  They allow installation to multiple locations,
# and running arbitrary scripts post-install.
#

#
# deploy: --Install stuff, and perform actions to re-start/re-init.
#
deploy:	var-defined[DEPLOY_HOSTS]
deploy:	$(DEPLOY_HOSTS:%=deploy[%])

#
# deploy: --Cleanup deploy's staging root directory.
#
deploy:
	$(RM) -r .deploy

#
# deploy[%]: --Deploy to a particular (possibly non-local) host.
#
deploy[%]:	deploy-action[%] deploy-install[%]
	$(ECHO_TARGET)

deploy-action[%]:	deploy-install[%]
	$(ECHO_TARGET)

deploy-install[%]:	.deploy
	$(ECHO_TARGET)
	scp -r .deploy/$(prefix)/* $(*):$(DEPLOY_ROOT)/$(prefix)

#
# deploy-install[localhost]: --Specialised actions for local deployment
#
deploy-install[localhost]:	.deploy
	$(ECHO_TARGET)
	cp -Rr .deploy/$(prefix)/* $(DEPLOY_ROOT)/$(prefix)

#
# .deploy: --Create the staging root for deployments.
#
.deploy:
	$(ECHO_TARGET)
	$(MAKE) $(MFLAGS) install DESTDIR=$$(pwd)/.deploy

.PHONY: deploy-clean
clean:	deploy-clean
deploy-clean:
	$(RM) -r .deploy

distclean:	deploy-clean
