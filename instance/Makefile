
box = isovault
display = --fullscreen

is_built = boxen images -a | grep -q '^$(box)[[:space:]]' 
is_deployed = { boxen 2>/dev/null show $(box) -j || true; } | grep -q '^[[:space:]]*"Deployed": true,'
is_running = { boxen 2>/dev/null show $(box) -j || true; } | grep -q '^[[:space:]]*"Up": true'

sources := Boxenfile $(foreach dir,etc dotfiles root,$(shell find $(dir) -type f) )

default:
	@echo box=$(box)
	@echo -n 'is_built='; $(is_built) && echo '1' || echo '0'
	@echo -n 'is_deployed='; $(is_deployed) && echo '1' || echo '0'
	@echo -n 'is_running='; $(is_running) && echo '1' || echo '0'

.built: $(sources)
	boxen build . $(box) 
	touch $@

build: .built 

rebuild: clean build

.deployed: .built
	@$(is_deployed) && echo "already deployed" || boxen deploy --netboot $(display) $(box)
	fixdns $(box) || true
	touch $@

deploy: .deployed

start: .deployed
	@$(is_running) && echo "already running" || boxen start $(display) $(box)

stop:
	@$(is_running) && boxen stop --force $(box) || echo "not running"

destroy: stop
	@$(is_deployed) && boxen destroy --force $(box) || echo "not deployed"

clean: destroy
	@$(is_built) && { boxen rmi --force $(box) || true; } || true
	rm -f .built .deployed

modify: stop
	vmx cat $(box) >before.vmx
	vmx modify $(box) $(vmx_options)
	vmx cat $(box) >after.vmx
	diff before.vmx after.vmx || true

pull-root-bin:
	./bin/pull-root-bin
