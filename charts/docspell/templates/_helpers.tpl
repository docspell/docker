{{/*
Expand the name of the chart.
*/}}
{{- define "docspell.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "docspell.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "docspell.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "docspell.labels" -}}
helm.sh/chart: {{ include "docspell.chart" . }}
{{ include "docspell.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "docspell.selectorLabels" -}}
app.kubernetes.io/name: {{ include "docspell.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "docspell.configVariables" -}}
{{- $configVars := dict }}
{{- range $source := .Sources -}}
{{- $configVars = mergeOverwrite $configVars (deepCopy $source) -}}
{{- end }}
{{- range $name, $config := $configVars }}
{{- if $config.value }}
- name: {{ $name }}
{{- if $config.template }}
  value: {{ tpl $config.value $.Root | quote }}
{{- else }}
  value: {{ $config.value | quote }}
{{- end }}
{{- else if $config.valueFrom }}
- name: {{ $name }}
{{- if $config.template }}
  valueFrom: {{- tpl ($config.valueFrom | toYaml) $.Root | nindent 4 }}
{{- else }}
  valueFrom: {{- $config.valueFrom | toYaml | nindent 4 }}
{{- end }}
{{- else }}
{{- end }}
{{- end }}
{{- end }}