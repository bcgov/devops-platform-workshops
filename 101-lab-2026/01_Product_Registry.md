# Product registry 

The BC Platform Services [Product Registry](https://registry.developer.gov.bc.ca/) (often abbreviated to 'the registry') is a directory of all the active products in OpenShift and the BC Gov's Public Cloud offerings. 

## Purpose of the registry

The registry links the people responsible for maintaining the software product with the set of namespaces where the computing work is done. Since these are usually just alphanumeric codes, it's much easier to be prompted about the name of the project and people involved instead of just a set characters such as `d8f105-dev`. This helps the Platform Services Team to identify the key contacts for each product and how to reach them when needed. 

## The provisioner 

The registry isn't just a list of contact information. It can interact with OpenShift via an internal tool called 'the provisioner' to perform tasks such as: 
- Managing administrator access 
- Adjusting resource quotas for CPU, RAM and storage
- Creating and deleting products and their associated namespaces in OpenShift  

In short, changes made in the registry can trigger changes in OpenShift. 

## Contact details

The product owner and technical leads listed in the registry will have `admin` access to your OpenShift namespaces. They can then [grant access](https://developer.gov.bc.ca/docs/default/component/platform-developer-docs/docs/openshift-projects-and-access/grant-user-access-openshift/) to other developers on your team. 

It is important to keep these details up to date so that this access is issued appropriately, and so that your team can be contacted. 


## Create a temporary product set 

- Create a temporary product set to use in this training
- Set yourself as the product owner
- Set Matt Spencer and Billy Li as technical leads

## Quota change

- Set prod and test to 0. 
- Adjust quotas for dev and tools? 


##

