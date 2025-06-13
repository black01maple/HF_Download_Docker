from typing import Literal, Union
from pathlib import Path
import os

os.environ["HF_ENDPOINT"] = "https://hf-mirror.com"

from huggingface_hub import snapshot_download
from huggingface_hub.errors import GatedRepoError, RepositoryNotFoundError, RevisionNotFoundError, LocalEntryNotFoundError


def download_hf(repo_id: str, repo_type: str = "model", revision: Union[str, None] = None,
                token: Union[str, None] = None):
    """
    从HuggingFace下载完整的模型或数据集。

    Args:
        repo_id (str): 仓库ID。
        repo_type (str, optional): 仓库类型（模型或数据集）。默认为 "model"。
        revision (str, optional): 要下载的版本（分支、标签、commit hash）。默认为 None。
        local_dir (str, optional): 下载到的本地目录。默认为 None。
        token (str, optional): huggingface的个人token、
    """
    if repo_id.count('/') != 1:
        print('仓库名称格式错误！请检查仓库名称，仓库名称格式通常为："<用户或组织的名称>/<仓库名称>"。')
        return '下载终止'
    _, repo_name = repo_id.split('/')
    local_dir_concat = Path("/opt/saved_model_parameters") / repo_name
    if repo_type not in ["model", "dataset", "space"]:
        print('仓库类型错误！请检查仓库类型，支持的仓库类型有 "model"、"dataset"、"space" 三种。')
        return '下载终止'

    print(f"正在下载仓库 {repo_id} ...")
    try:
        snapshot_download(
            repo_id=repo_id,
            repo_type=repo_type,
            revision=revision,
            local_dir=local_dir_concat,
            token=token
        )
    except GatedRepoError:
        print("仓库无权限！需要使用有权限的账号，并传入账号的token。")
        return '下载终止'
    except RepositoryNotFoundError:
        print("找不到该仓库！请检查仓库地址。")
        return '下载终止'
    except RevisionNotFoundError:
        print("找不到该仓库的指定版本！请检查版本名称。")
        return '下载终止'
    except LocalEntryNotFoundError:
        print("网络连接失败！请检查网络是否可达。")
        return '下载终止'
    except Exception as e:
        print(f"下载失败！报错原因：\n{str(e)}")
        return '下载终止'
    return '下载完成'


if __name__ == "__main__":
    repo_id = os.getenv("repo_id")
    repo_type = os.getenv("repo_type", "model")
    revision = os.getenv("branch", None)
    token = os.getenv("token", None)
    if repo_id is None:
        raise Exception("未传入仓库名称！请通过 -e <repo_id> 来传入需要下载的仓库名称。")

    closing_remark = download_hf(
        repo_id=repo_id,
        repo_type=repo_type,
        revision=revision,
        token=token
    )
    print(closing_remark)