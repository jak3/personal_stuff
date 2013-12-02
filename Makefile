info:
		find . -regex .+~
		find . -name *.swp
do:
		find . -regex .+~ -delete
		find . -name *.swp -delete
