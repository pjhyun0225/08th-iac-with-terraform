# 주제

Provider 버전 관리 (required_providers, version constraint)


# 학습 내용

우선 Provider 란 쉽게 infrastructure 의 type 이라고 할 수 있다. 예시로 AWS, GCP, Azure 가 각각 provider 라고 생각하면 된다.

Terraform은 클라우드 리소스를 직접 만드는 도구가 아니라, **Provider**(AWS, Azure, GCP, Kubernetes, GitHub 등)를 통해 클라우드 API를 호출한다. 그렇기 때문에 Terraform은 provider 버전이 매우 중요하다.

AWS provider만 해도 아래와 같이 업데이트가 자주 일어나는데,

- 리소스 속성 추가
- 속성 변경 (Deprecated)
- 동작 변경
- Breaking Chang

이를 제어하기 위해 Terraform은 두 가지 기능을 제공한다.

* 참고로 AWS 프로바이더 구성을 Azure나 GCP로 변경하는 것은 불가능함.

terraform 블록의 required_providers 블록 내에 <로컬 이름> = {  }으로 여러개의 프로바이더를 정의할 수 있다. 여기서 사용되는 로컬 이름은 테라폼 모듈내에서 고유해야 한다.

## **required_providers**

**`required_providers` 블록의 구조 및 의미**

- `terraform` 블록 내부에 `required_providers` 블록을 선언해야 한다.
- 이 블록은 해당 루트 모듈(root module)이 사용하는 프로바이더(provider)들을 명시하고, Terraform이 어떤 공급자 플러그인을 설치해야 하는지를 알려준다.
- 각 프로바이더 요구사항은 **로컬 이름(local name)**, **소스 주소(source)**, **버전 제약(version)** 으로 구성된다.

```bash
terraform {
  required_providers {
    architect-http = {
      source = "architect-team/http"
      version = "~> 3.0"
    }
    http = {
      source = "hashicorp/http"
    }
    aws-http = {
      source = "terraform-aws-modules/http"
    }
  }
}
```

여기서 architect-http의 경우

- 로컬 provider 이름: `architect-http`
- source: `architect-team/http`
    - Terraform Registry 주소는 `registry.terraform.io/architect-team/http`
- version constraint: `~> 3.0`

**required_providers의 역할**

1) Provider의 “공식 주소(source)”를 Terraform에게 알려준다.

예:

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
```

여기서:

- `aws` → provider의 **로컬 이름(별칭)**
- `source` → provider의 **레지스트리 주소**

Terraform은 이 정보를 보고 “AWS provider는 registry.terraform.io/hashicorp/aws에서 받아오면 되겠구나” 라고 이해하고 init 시 다운로드한다.

2) Provider의 **버전 제약(version constraints)** 을 선언한다.

예:

```hcl
version = "~> 5.0"
```

Terraform은 이것을 보고 "AWS provider는 5.x 버전만 설치해야 한다" 라고 이해한다.

즉, `required_providers`에서 버전을 지정하는 것이 **Provider 버전 관리의 핵심**입니다.

3) Terraform init 시 어떤 Provider를 설치할지 결정한다,

`terraform init` 의 동작 흐름:

1. `required_providers` 항목 확인
2. provider source 주소 확인
3. 버전 제약 확인
4. 최적의 버전 선택
5. provider 다운로드
6. `.terraform.lock.hcl` 생성 또는 업데이트

 즉,`required_providers`가 Terraform이 **무슨 Provider를 설치해야 할지** 명시해주는 것

4) 모듈(module) 간 Provider 충돌 방지 역할

Terraform에는 두 가지 모듈 종류가 있는데,

- **root module**: 실제 `terraform apply`를 실행하는 최상위 모듈
- **child module**: 재사용 가능한 모듈

여기서 중요한 규칙은

“Provider 사용은 root module에서 설정해야 한다.” 라는 것이다.

즉, child module에서는 단순히 provider를 **참조**하고, 그 provider가 어떤 버전인지, 어디서 오는지는 root module의 `required_providers`가 책임지며 Provider 충돌을 방지한다.

**required_providers와 provider 블록의 차이**

| 요소 | 역할 |
| --- | --- |
| **required_providers** | Provider를 “어디서”, “어떤 버전으로” 다운받을지 지정 |
| **provider “aws” {}** | 해당 Provider를 “어떤 설정으로” 사용할지 지정 |

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}
```

- required_providers → 다운로드 정보 + 버전 관리
- provider → 설정 값(region, profile 등)

---

## **버전 제약(Version Constraints)**

**Version Constraints**는 Terraform에서 Provider 또는 Terraform CLI의 **버전을 어떤 범위로 제한(specify)** 하는 규칙으로, “이 Provider는 이 범위의 버전만 사용하도록 강제하라” 라고 Terraform에게 알려주는 문법이다.

Terraform은 Provider(예: AWS, GCP, Azure, GitHub)와 Terraform 자체(본체)를 독립적으로 버전 관리한다. 그래서 코드가 어떤 환경에서 실행되더라도 **항상 동일한 버전**을 사용하도록 제약이 필요하다.

Terraform docs의 공식 버전 제약 문법:

| 문법 | 의미 |
| --- | --- |
| `= 3.1.0` | 특정 버전만 허용 |
| `>= 3.0` | 3.0 이상 |
| `<= 3.5` | 3.5 이하 |
| `< 4.0.0` | 4.0 미만 버전 |
| `!= 3.2.0` | 특정 버전 제외 |
| `~> 3.0` | 3.0 이상 4.0 미만 (가장 많이 사용) |

**“~>” (Pessimistic constraint) 의 직관적 설명**

- `~> 3.1.0` → patch만 자동 업데이트
- `~> 3.1` → minor까지 자동 업데이트
- `~> 3.0` → major 변경은 차단(3.x.x까지만)

| 목적 | 설명 |
| --- | --- |
| **1. 항상 동일한 Provider 버전 사용 보장** | 팀원, 서버, CI/CD 어디서 실행해도 동일한 버전 유지 |
| **2. Breaking Change 차단** | Provider 메이저 업데이트 때문에 코드가 갑자기 깨지지 않음 |
| **3. 예측 가능한 인프라** | 어떤 버전으로 실행되는지 정확히 알 수 있음 |
| **4. 안정적인 운영 환경 확보** | 장기 유지보수 시 혼란 방지 |

Version Constraints가 없다면 아래와 같은 문제가 발생할 수 있는데,

1) Provider가 자동으로 최신 버전을 설치해버림

예시:

```hcl
required_providers {
  aws = {
    source = "hashicorp/aws"
    # version 없음!
  }
}
```

이러면:

- 오늘은 aws provider 5.0.1 설치
- 내일은 5.1.0 설치
- 다음 주는 6.0.0(메이저 업그레이드) 설치 → 코드 깨짐

= **인프라가 시도 때도 없이 깨지는 “불안정한 환경”이 됨**

2) 코드가 어느 날 갑자기 오류 발생

Provider가 업데이트되면서:

- 속성 이름 변경
- 요구 parameter 변경
- 동작 방식 변경
- API 변경

→ **기존 Terraform 코드가 더 이상 작동하지 않을 수 있음**

3) 서로 다른 개발자/서버가 서로 다른 버전 사용

- 로컬에서는 Terraform code가 정상
- CI에서는 다른 provider 버전을 사용해서 오류
- 운영 서버에서는 또 다른 버전…

**즉, 환경마다 결과가 일관되지 않음 → 인프라 붕괴 위험**

“나도 모르게 Provider가 업그레이드되는 순간, 인프라 전체가 터질 수 있음.”

**Version Constraints + Lock 파일 = 완전한 버전 관리**

Terraform의 버전 관리는 **2단계 구조**로 되어 있다.

1) Version Constraints (코드에서 제약)

- 어떤 버전 범위만 허용하는지 지정
- 예: `~> 5.0`

2) `.terraform.lock.hcl` (잠금 파일)

`terraform init` 시 자동 생성되는 파일로:

- 현재 설치된 provider의 정확한 버전 기록
- 해시 값 포함 → 무결성 검증

결과:

> 팀원, 서버, CI/CD 등 어디에서 terraform을 실행해도
> 
> 
> **항상 동일한 버전이 설치되어 완전히 동일한 결과를 만들어냄.**
> 

# 출처

https://developer.hashicorp.com/terraform/language/providers/requirements?utm_source=chatgpt.com

https://developer.hashicorp.com/terraform/language/block/provider

https://developer.hashicorp.com/terraform/language/expressions/version-constraints?utm_source=chatgpt.com

# 추가

- 추가로 공유하고 싶은 내용을 작성해 주세요. (어떤 것이든 좋습니다!)
