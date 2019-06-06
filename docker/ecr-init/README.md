# Helper image for initializing an ECR repository

The image uses `awscli` and `podman` to load images to ECR repositories.

# Usage

Configuration is provided via environment variables

* ECR_INIT_PREFIX : prefix for ecr repositories, e.g. "$accountid$.dkr.ecr.$region$.amazonaws.com/$prefix$"
* ECR_INIT_WAIT_COND_URL : optional wait condition handle to notify on completion
* ECR_INIT_IMAGE_X : Image to load

Images must be sequential, starting with `ECR_INIT_IMAGE_1`, the source
image name after the last `/` is appended to the `ECR_INIT_PREFIX` to
give the target image name.

An EC2 IAM instance profile or ECS task role should be used to provide
credentials / permissions.
