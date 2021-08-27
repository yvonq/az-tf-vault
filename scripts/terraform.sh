cd terraform


terraform init

if [ $1 == "plan" ]
then
    terraform plan -compact-warnings
elif [ $1 == "init" ]
then
	terraform init -reconfigure
elif [ $1 == "validate" ]
then
	terraform validate && terraform output
elif [ $1 == "destroy" ]
then
	terraform destroy -auto-approve && terraform output
elif [ $1 == "apply" ]
then
    terraform apply -auto-approve && terraform output 
else
    echo "Error" && exit 2
fi
