# 주제

학습 주제를 작성해 주세요.

# 요약

- 학습 내용을 간단하게 요약해 주세요.

# 학습 내용
## 1장~3장

### 1장: IaC와 테라폼

**IaC의 전략**

IaC는 코드로 인프라를 관리할 수 있도록 하는 코드형 인프라이다. 

기존에는 인프라 자동화를 위해서 문서화를 하고, 인프라 종속성을 분석하며, 자원 변경을 수시로 변경하는 등의 복잡한 과정을 걸쳐야했다. 그러나 이런 과정대신 좋은 코드가 좋은 인프라 자동화 방식으로 이어지도록 만들어주는게 IaC이다.

**IaC 도입의 장점**

- 속도와 효율성 : 수동 작업 시보다 빠르고, 생성성을 높일 수 있다.
- 버전 관리 : 코드 형태로 관리하기 때문에 버전 관리 툴과 연계가 가능하다.
- 협업 : 파일 형태로 존재하기 때문에 공유가 쉬우며, 버전관리 툴과 연계되어 공동 작업도 용이하게 할 수 있다.
- 재사용성 : 표준화 된 구성을 패키징하면 매번 새로 코드를 구성하지 않고 기존 모듈을 활용해 배포할 수 있다.
- 기술의 자산화

다만, IaC를 도입하기 위해서는 이 새로운 IaC 라는 도구를 동부해야하며, IaC 뿐 아니라 대상이 되는 인프라 지식이 함께 필요하다는 점도 존재한다.

**테라폼**

테라폼은 terraform apply와 같은 명령으로 구현된 동작으로 만들어진 코드를 실행하고 배포하는 방식을 취한다. 그러나 테라폼으로 대상 인프라와 서비스를 작업하기 위해서는 대상의 제공자인 **프로바이더(provider)**의 인터페이싱이 필요하다.

각 인프라와 서비스는 고유의 API를 가지며, 프로바이더는 각 API 명세를 테라폼 코드로 호출해 동작한다.

→ 테라폼은 다양한 프로바이더와 조합해 다중 클라우드와 하이브리드 인프라를 지원함

**테라폼 제공 유형**

- **On-premise**: 일반적으로 Terraform이라고 불리는 형태. 사용자의 컴퓨팅 환경에 오픈소스 바이너리 툴인 테라폼이 구성되며 가장 널리 이용됨
- **Hostesd SaaS**: HCP Terraform(Terraform Cloud)으로 불리는 서비스형 소프트웨어로 제공되는 구성 환경으로 하시코프가 관리하는 서버 환경에서 제공
- **Priviate Install**: Terraform Enterprise라고 불리는 서버 설치형 구성 환경. 기업의 사내 정책에 따라 프로비저닝과 관리가 외부 네트워크와 격리되어 이루어지는 환경

**테라폼 라이선스**

테라폼은 1.6.0 버전부터 새로운 비지니스 소스 라이선스(BSL) 하에 배포된다.

허가된 사용의 예는 다음과 같다.

- 개인 사용자가 개인 프로젝트에서 테라폼을 사용하는 경우
- 대학교 수업에서 교육 목적으로 테라폼을 사용하는 경우
- 비영리 단체가 인프라 관리 자동화를 위해 테라폼을 사용하는 경우
- 기업이 내부 프로젝트에서 자체 인프라 관리를 위해 테라폼을 사용하는 경우

상업적 사용에 경우는 제한이 될 수 있는데, 아래와 같이 상업적 용도로 소프트웨어를 사용하는 경우에는 별도의 라이선스 계약이 필요할 수 있다.

- 클라우드 서비스 제공자가 테라폼을 사용하여 고객에게 인프라 자동화 서비스를 제공하는 경우
- 소프트웨어 회사가 테라폼을 사용하여 상용 소프트웨어 제품을 개발하는 경우

### 2장/3장: 실행환경 구축 및 주요 커맨드

1. 테라폼 설치(MacOS)

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

![스크린샷 2025-11-10 오후 8.32.20.png](attachment:09dc74b9-9ffe-4c2d-a3e2-a678dcf3519b:스크린샷_2025-11-10_오후_8.32.20.png)

`terrafrom` 명령어로 확인한 테라폼의 주요 커맨드

```bash
Usage: terraform [global options] <subcommand> [args]

The available commands for execution are listed below.
The primary workflow commands are given first, followed by
less common or more advanced commands.

Main commands:
  init          Prepare your working directory for other commands
  validate      Check whether the configuration is valid
  plan          Show changes required by the current configuration
  apply         Create or update infrastructure
  destroy       Destroy previously-created infrastructure

All other commands:
  console       Try Terraform expressions at an interactive command prompt
  fmt           Reformat your configuration in the standard style
  force-unlock  Release a stuck lock on the current workspace
  get           Install or upgrade remote Terraform modules
  graph         Generate a Graphviz graph of the steps in an operation
  import        Associate existing infrastructure with a Terraform resource
  login         Obtain and save credentials for a remote host
  logout        Remove locally-stored credentials for a remote host
  metadata      Metadata related commands
  modules       Show all declared modules in a working directory
  output        Show output values from your root module
  providers     Show the providers required for this configuration
  refresh       Update the state to match remote systems
  show          Show the current state or a saved plan
  stacks        Manage HCP Terraform stack operations
  state         Advanced state management
  taint         Mark a resource instance as not fully functional
  test          Execute integration tests for Terraform modules
  untaint       Remove the 'tainted' state from a resource instance
  version       Show the current Terraform version
  workspace     Workspace management

Global options (use these before the subcommand, if any):
  -chdir=DIR    Switch to a different working directory before executing the
                given subcommand.
  -help         Show this help output or the help for a specified subcommand.
  -version      An alias for the "version" subcommand.
```

**init :** `terraform [global option] init [option]`

init 명령은 테라폼 구성 파일이 있는 작업 디렉터리를 초기화하는데 사용된다.

→ 이 작업을 실행하는 디렉터리를 루트 모듈이라고 부름

init 명령은 테라폼에서 사용되는 프로바이더, 모듈 등의 지정된 버전에 맞춰 루트 모듈을 구성하는 역할 수행한다.

```bash
jihyeon@JH-Mac 03.start % terraform plan
╷
│ Error: Inconsistent dependency lock file
│ 
│ The following dependency selections recorded in the lock file are inconsistent with the current configuration:
│   - provider registry.terraform.io/hashicorp/local: required by this configuration but no version is selected
│ 
│ To make the initial dependency selections that will initialize the dependency lock file, run:
│   terraform init
╵
jihyeon@JH-Mac 03.start % terraform init
Initializing the backend...
Initializing provider plugins...
- Finding latest version of hashicorp/local...
- Installing hashicorp/local v2.5.3...
- Installed hashicorp/local v2.5.3 (signed by HashiCorp)
Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
jihyeon@JH-Mac 03.start % terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # local_file.abc will be created
  + resource "local_file" "abc" {
      + content              = "abc!"
      + content_base64sha256 = (known after apply)
      + content_base64sha512 = (known after apply)
      + content_md5          = (known after apply)
      + content_sha1         = (known after apply)
      + content_sha256       = (known after apply)
      + content_sha512       = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "./abc.txt"
      + id                   = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

**-upgrade**

0.14 버전 이후부터 프로바이더 종속성을 고정시키는 . terraform.lock.hcl이 추가되는데, 작업 당시의 버전 정보를 기입하고  . terraform.lock.hcl 파일이 있는 경우 해당 파일에 명시된 버전으로 init을 수행한다. 이후 작업자가 의도적으로 버전을 변경하거나 코드에 명시한 다른 버전으로 변경하려면 terraform init -upgrade를 수행해야한다.

**validate**: `terraform [global option] validate [options]`

validate는 커맨드 단어 의미대로 디렉터리에 있는 테라폼 구성 파일의 유효서을 확인한다.

→ 이때 원격작업니아 API 작업은 발생하지 않고 코드적인 유효성만 검토함

**HCL**

HCL은 하시코프사에서 IaC와 구성 정보를 명시하기 위해 개발된 오픈 소스 도구이다.

테라폼에서는 HCL이 코드의 영역을 담당한다.

다수의 프로비저닝 대상 인프라와 서비스는 JSON과 YAML 방식의 기계 친화적인 언어로 소통하지만 HCL은 JSON과 YAML같은 방식을 사용하지 않는다.

JSON은 구문이 길어질 수 있고, 주석을 지원하지 않는다는 단점이 존재하고, YAML은 처음 접하는 사용자의 경우 익숙해지는데 어려움을 겪으며, 관리대상이 많아지고 구성이 복잡해지면, 리소스 구성을 파악하기가 어렵다는 단점이 있다.

**테라폼 블록**

테라폼 블록은 테라폼의 구성을 명시하는 데 사용된다. 테라폼 버전, 프로바이더 버전과 같은 값 이외에 버전을 면시적으로 선언하고 필요 조건 입력으로 실행 오류를 최소화 하는 것을 권장한다.

```bash
terraform{
	required_version = "~> 1.8.0"
	
	required_providers{
		random = {
			version = ">= 3.0.0, < 3.6.0"
		}
		aws = {
			version = "~>5.0"
		}
	}
	
	cloud {
		organization = "<MY_ORG_NAME>"
		
		workpaces {
			name = "my-first-workpace"
		}
	}
	
	backend "local" {
		path = "relative/path/to/terraform.tfstate"
	}
}
```

- cloud 블록

: HCP Terraform, Terraform Enterprise는 CLI, VCS, API 기반의 실행 방식을 지원하고 cloud 블록으로 선언한다. cloud 블록은 1.1 버전에 추가된 선언으로 기존에는 State 저장소를 의미하는 backend의 remote 항목으로 설정했다.

- 백엔드 블록

: 벡엔드 블록의 구성은 테라폼 실행 시 저장되는 State(상태 파일) 의 저장 위치를 선언한다. 주의할 점은 하나의 백엔드만 허용한다는 점이다. 테라폼은 State의 데이터를 사용해 코드로 관리된 리소스를 탐색하고 추적한다.

# 추가

- 추가로 공유하고 싶은 내용을 작성해 주세요. (어떤 것이든 좋습니다!)
