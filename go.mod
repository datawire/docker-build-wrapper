module github.com/datawire/docker-build-wrapper

go 1.12

require github.com/docker/cli v0.0.0-20190711175710-5b38d82aa076 // v19.03.1

// The following replacements and requirements are adapted from
// `vendor.conf` in a checkout of the above github.com/docker/cli
// version, using the following command:
//
//     < vendor.conf \
//     sed 's/#.*//' | \
//     awk '
//
//         BEGIN {
//             split("", requires);
//             split("", replaces);
//         }
//
//         NF == 2 {
//             requires[length(requires)+1] = $1 " " $2;
//         }
//
//         NF == 3 {
//             sub(/^.*:\/\//, "", $3);
//             sub(/\.git$/, "", $3);
//             replaces[length(replaces)+1] = $1 " => " $3 " " $2;
//         }
//
//         END {
//             print "require (";
//             for (i in requires) {
//                 print "\t" requires[i];
//             }
//             print ")";
//
//             print "";
//
//             print "replace (";
//             for (i in replaces) {
//                 print "\t" replaces[i];
//             }
//             print ")";
//         }
//
//         '
//
// And then letting `go build . && go mod vendor` clean it up.  For
// some reason, `go mod tidy` breaks the build (verified with Go
// 1.12.7 and Go 1.12.9).

require (
	cloud.google.com/go v0.34.0 // indirect
	github.com/Azure/go-ansiterm v0.0.0-20170929234023-d6e3b3328b78 // indirect
	github.com/agl/ed25519 v0.0.0-20170116200512-5312a6153412 // indirect
	github.com/asaskevich/govalidator v0.0.0-20180720115003-f9ffefc3facf // indirect
	github.com/beorn7/perks v0.0.0-20190414131216-e7f67b54abbe // indirect
	github.com/containerd/fifo v0.0.0-20190226154929-a9fb20d87448 // indirect
	github.com/containerd/typeurl v0.0.0-20190228175220-2a93cfde8c20 // indirect
	github.com/coreos/etcd v3.3.12+incompatible // indirect
	github.com/cpuguy83/go-md2man v1.0.8 // indirect
	github.com/dgrijalva/jwt-go v2.6.0+incompatible // indirect
	github.com/docker/compose-on-kubernetes v0.4.23 // indirect
	github.com/docker/docker-credential-helpers v0.6.1 // indirect
	github.com/docker/go v0.0.0-20160303222718-d30aec9fd63c // indirect
	github.com/docker/go-connections v0.4.0 // indirect
	github.com/docker/go-metrics v0.0.0-20170502235133-d466d4f6fd96 // indirect
	github.com/docker/go-units v0.4.0 // indirect
	github.com/docker/libtrust v0.0.0-20150526203908-9cbd2a1374f4 // indirect
	github.com/docker/licensing v0.0.0-20190320170819-9781369abdb5 // indirect
	github.com/docker/swarmkit v0.0.0-20190520182030-48eb1828ce81 // indirect
	github.com/evanphx/json-patch v4.1.0+incompatible // indirect
	github.com/gogo/googleapis v1.2.0 // indirect
	github.com/google/gofuzz v0.0.0-20170612174753-24818f796faf // indirect
	github.com/google/shlex v0.0.0-20181106134648-c34317bd91bf // indirect
	github.com/google/uuid v1.1.1 // indirect
	github.com/googleapis/gnostic v0.2.0 // indirect
	github.com/gorilla/mux v1.7.0 // indirect
	github.com/grpc-ecosystem/grpc-gateway v0.0.0-20170714172803-1a03ca3bad1e // indirect
	github.com/hashicorp/go-version v0.0.0-20180322230233-23480c066577 // indirect
	github.com/imdario/mergo v0.3.7 // indirect
	github.com/inconshreveable/mousetrap v1.0.0 // indirect
	github.com/json-iterator/go v1.1.6 // indirect
	github.com/konsorten/go-windows-terminal-sequences v1.0.2 // indirect
	github.com/mattn/go-shellwords v1.0.5 // indirect
	github.com/matttproud/golang_protobuf_extensions v1.0.1 // indirect
	github.com/miekg/pkcs11 v0.0.0-20190225171305-6120d95c0e95 // indirect
	github.com/mitchellh/mapstructure v0.0.0-20180715050151-f15292f7a699 // indirect
	github.com/moby/buildkit v0.0.0-20190513182223-f238f1efb04f // indirect
	github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd // indirect
	github.com/modern-go/reflect2 v0.0.0-20180701023420-4b7aa43c6742 // indirect
	github.com/opencontainers/runtime-spec v0.0.0-20190207185410-29686dbc5559 // indirect
	github.com/pkg/errors v0.8.1
	github.com/prometheus/client_golang v0.8.0 // indirect
	github.com/prometheus/client_model v0.0.0-20170216185247-6f3806018612 // indirect
	github.com/prometheus/common v0.0.0-20180518154759-7600349dcfe1 // indirect
	github.com/prometheus/procfs v0.0.0-20180612222113-7d6f385de8be // indirect
	github.com/russross/blackfriday v0.0.0-20160531111224-1d6b8e9301e7 // indirect
	github.com/shurcooL/sanitized_anchor_name v0.0.0-20151028001915-10ef21a441db // indirect
	github.com/sirupsen/logrus v1.4.1 // indirect
	github.com/spf13/cobra v0.0.3
	github.com/spf13/pflag v0.0.0-00010101000000-000000000000
	github.com/theupdateframework/notary v0.6.1 // indirect
	github.com/xeipuuv/gojsonpointer v0.0.0-20180127040702-4e3ac2762d5f // indirect
	github.com/xeipuuv/gojsonreference v0.0.0-20180127040603-bd5ef7bd5415 // indirect
	github.com/xeipuuv/gojsonschema v0.0.0-20160323030313-93e72a773fad // indirect
	golang.org/x/crypto v0.0.0-20190411191339-88737f569e3a // indirect
	golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3 // indirect
	golang.org/x/sync v0.0.0-20190227155943-e225da77a7e6 // indirect
	golang.org/x/sys v0.0.0-20190405154228-4b34438f7a67 // indirect
	golang.org/x/time v0.0.0-20180412165947-fbb02b2291d2 // indirect
	gopkg.in/inf.v0 v0.9.1 // indirect
	k8s.io/api v0.0.0-20190313235455-40a48860b5ab // indirect
	k8s.io/apimachinery v0.0.0-20190313205120-d7deff9243b1 // indirect
	k8s.io/client-go v11.0.0+incompatible // indirect
	k8s.io/klog v0.2.0 // indirect
	k8s.io/kube-openapi v0.0.0-20190320154901-5e45bb682580 // indirect
	k8s.io/kubernetes v1.14.0 // indirect
	k8s.io/utils v0.0.0-20190308190857-21c4ce38f2a7 // indirect
	sigs.k8s.io/yaml v1.1.0 // indirect
	vbom.ml/util v0.0.0-20170409195630-256737ac55c4 // indirect
)

replace (
	github.com/docker/docker => github.com/docker/engine v0.0.0-20190527180710-a00485409741
	github.com/jaguilar/vt100 => github.com/tonistiigi/vt100 v0.0.0-20190402012908-ad4c4a574305
	github.com/spf13/pflag => github.com/thaJeztah/pflag v1.0.3-0.20180821151913-4cb166e4f25a
)
