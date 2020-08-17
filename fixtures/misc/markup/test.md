### Example with user / group level access **(STARTER)**

Elements in the `allowed_to_push` / `allowed_to_merge` / `allowed_to_unprotect` array should take the
form `{user_id: integer}`, `{group_id: integer}` or `{access_level: integer}`. Each user must have access to the project and each group must [have this project shared](../user/project/members/share_project_with_groups.md). These access levels allow [more granular control over protected branch access](../user/project/protected_branches.md#restricting-push-and-merge-access-to-certain-users-starter) and were [added to the API in](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/3516) in GitLab 10.3 EE.

```shell
curl --request POST --header "PRIVATE-TOKEN: <your_access_token>" "https://gitlab.example.com/api/v4/projects/5/protected_branches?name=*-stable&allowed_to_push%5B%5D%5Buser_id%5D=1"
```

Example response:

```json
{
  "id": 1,
  "name": "*-stable",
  "push_access_levels": [
    {
      "access_level": null,
      "user_id": 1,
      "group_id": null,
      "access_level_description": "Administrator"
    }
  ],
  "merge_access_levels": [
    {
      "access_level": 40,
      "user_id": null,
      "group_id": null,
      "access_level_description": "Maintainers"
    }
  ],
  "unprotect_access_levels": [
    {
      "access_level": 40,
      "user_id": null,
      "group_id": null,
      "access_level_description": "Maintainers"
    }
  ],
  "code_owner_approval_required": "false"
}
```

### Create an IAM Policy

1. Navigate to the IAM dashboard and click on **Policies** in the left menu.
1. Click **Create policy**, select the `JSON` tab, and add a policy. We want to [follow security best practices and grant _least privilege_](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html#grant-least-privilege), giving our role only the permissions needed to perform the required actions.
   1. Assuming you prefix the S3 bucket names with `gl-` as shown in the diagram, add the following policy:

This is bad.Another good.

Strikethrough uses two tildes. ~~Scratch this.~~
