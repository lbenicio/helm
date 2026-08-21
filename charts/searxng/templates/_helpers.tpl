{{/*
Expand the name of the chart.
*/}}
{{- define "searxng.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Full name.
*/}}
{{- define "searxng.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "searxng.labels" -}}
helm.sh/chart: {{ include "searxng.name" . }}-{{ .Chart.Version | replace "+" "_" }}
{{ include "searxng.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{- toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "searxng.selectorLabels" -}}
app.kubernetes.io/name: {{ include "searxng.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
ServiceAccount name.
*/}}
{{- define "searxng.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "searxng.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Secret name holding SEARXNG_SECRET.
*/}}
{{- define "searxng.secretName" -}}
{{- if .Values.secret.existingSecret }}
{{- .Values.secret.existingSecret }}
{{- else }}
{{- printf "%s-secret" (include "searxng.fullname" .) }}
{{- end }}
{{- end }}

{{/*
SEARXNG_SECRET value: explicit value, existing Secret value (preserved on
upgrades), or a fresh random value.
*/}}
{{- define "searxng.secretValue" -}}
{{- if .Values.secret.value }}
{{- .Values.secret.value }}
{{- else }}
{{- $secret := lookup "v1" "Secret" .Release.Namespace (include "searxng.secretName" .) }}
{{- if and $secret (index $secret.data "SEARXNG_SECRET") }}
{{- index $secret.data "SEARXNG_SECRET" | b64dec }}
{{- else }}
{{- randAlphaNum 64 }}
{{- end }}
{{- end }}
{{- end }}
