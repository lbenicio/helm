{{/*
Expand the name of the chart.
*/}}
{{- define "stremio.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "stremio.fullname" -}}
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
Server fullname.
*/}}
{{- define "stremio.server.fullname" -}}
{{- printf "%s-server" (include "stremio.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Client fullname.
*/}}
{{- define "stremio.client.fullname" -}}
{{- printf "%s-client" (include "stremio.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "stremio.labels" -}}
helm.sh/chart: {{ include "stremio.name" . }}-{{ .Chart.Version | replace "+" "_" }}
{{ include "stremio.selectorLabels" . }}
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
{{- define "stremio.selectorLabels" -}}
app.kubernetes.io/name: {{ include "stremio.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
ServiceAccount name.
*/}}
{{- define "stremio.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "stremio.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Keel pod annotations.
*/}}
{{- define "stremio.keelAnnotations" -}}
{{- if .keel.enabled }}
keel.sh/policy: {{ .keel.policy | quote }}
keel.sh/trigger: {{ .keel.trigger | quote }}
keel.sh/pollSchedule: {{ .keel.pollSchedule | quote }}
{{- if .keel.matchTag }}
keel.sh/match-tag: {{ .keel.matchTag | quote }}
{{- end }}
{{- end }}
{{- end }}
