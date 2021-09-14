                    if (pushed > 0) {
                        flow[next, source] -= pushed;
                        return pushed;
                    }
                }
            }
            return 0;
        }

        private const long modulo = (long)1e9 + 7;
    }
}