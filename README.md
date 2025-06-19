# create\_harbor\_daemonset



클러스터 내 모든 노드에 Harbor 2.8.2 관련 이미지를 사전 캐싱(Pull)하도록\
DaemonSet을 자동 생성하는 Kubernetes 스크립트입니다.

---

## 🛠️ 목적 (Purpose)

- Harbor 구성 요소별 이미지를 각 노드에 항상 pull 상태로 유지
- 신규 노드 추가 시 자동으로 이미지 pull (DaemonSet 특성)
- 운영 환경에서 이미지 프리로딩, 네트워크 장애 대비

---

## 📄 사용법 (How to use)

### 1. 클론 및 이동

```bash
git clone git@github.com:pu4ro/create_harbor_daemonset.git
cd create_harbor_daemonset
```

### 2. 실행 권한 부여

```bash
chmod +x deploy-harbor-daemonsets.sh
```

### 3. 스크립트 실행

```bash
./deploy-harbor-daemonsets.sh
```

- 네임스페이스(`daemonset-harbor`)가 자동 생성됩니다.
- 각 Harbor 구성요소별로 DaemonSet이 실행됩니다.

---

## ⚙️ 주요 내용

- **네임스페이스:** `daemonset-harbor`
- **이미지 리스트:** Harbor 2.8.2 주요 컴포넌트 10종
- **컨테이너 명령:** `tail -f /dev/null` (CPU/메모리 사용 최소)
- **리소스:** requests 8Mi/5m, limits 16Mi/20m
- **생성된 DaemonSet은 이미지 pull 목적 외 기능 없음**

---

## 🧩 커스터마이징

- **네임스페이스 변경:**\
  스크립트 내 `NAMESPACE` 변수 수정
- **이미지 추가/삭제:**\
  `IMAGES` 배열 편집
- **자원 할당량:**\
  `resources` 값 조정
- **Pull Secret, nodeSelector 등 필요시 스펙 추가**

---

## 🧹 삭제 (Cleanup)

네임스페이스 전체 삭제:

```bash
kubectl delete ns daemonset-harbor
```

특정 DaemonSet만 삭제:

```bash
kubectl -n daemonset-harbor delete daemonset <daemonset-name>
```

---

---

## 📬 문의/기여 (Contact & Contribute)

- [Issues](https://github.com/pu4ro/create_harbor_daemonset/issues) 또는 PR 환영!
- 자유롭게 Fork/사용 가능합니다.

---

\*\*Made with ❤️ by \*\*[**pu4ro**](https://github.com/pu4ro)


